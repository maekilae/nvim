-- 1. Hook for builds
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local spec = ev.data.spec
		if (ev.data.kind == 'install' or ev.data.kind == 'update') and spec.data and spec.data.build then
			print("Building: " .. spec.name)
			vim.system({ spec.data.build }, { cwd = ev.data.path })
		end
	end
})

local all_native_specs = {}
local seen_plugins = {} -- Prevent duplicate adds

local function parse_and_collect(plugins)
	if plugins.enabled then
		if plugins.enabled == false then
			return
		end
	end
	if not plugins then return end

	local list = (type(plugins) == "table" and (plugins.src or type(plugins[1]) == "string"))
	    and { plugins }
	    or plugins

	for _, p in ipairs(list) do
		local spec = type(p) == "string" and { src = p } or p
		local src = spec.src or spec[1]

		if src and not seen_plugins[src] then
			seen_plugins[src] = true -- Mark as handled
			if not src:match("://") and not src:match("git@") then
				src = "https://github.com/" .. src
			end

			if spec.deps and type(spec.deps) == "table" then
				for _, d in pairs(spec.deps) do
					parse_and_collect(d)
				end
			end

			table.insert(all_native_specs, {
				src = src,
				name = spec.name,
				version = (spec.tag and spec.tag ~= "*") and spec.tag or nil,
				data = {
					build = spec.build,
				},
				opts = spec.opts,
				keys = spec.keys,
				config = spec.config
			})
		end
	end
end

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"

if vim.fn.isdirectory(plugin_dir) == 1 then
	local files = vim.fn.readdir(plugin_dir)
	for _, file in ipairs(files) do
		if file:match("%.lua$") then
			local module_name = "plugins." .. file:gsub("%.lua$", "")

			local ok, plugin_table = pcall(require, module_name)
			if ok then
				parse_and_collect(plugin_table)
			else
				print("Error loading " .. module_name .. ": " .. tostring(plugin_table)) -- DEBUG
			end
		end
	end
end

-- 4. Final Add and Sync
if #all_native_specs > 0 then
	print("Adding " .. #all_native_specs .. " plugins via vim.pack") -- DEBUG
	vim.pack.add(all_native_specs)
end

for _, spec in pairs(all_native_specs) do
	if spec.opts then
		local clean_name = spec.src:match(".*/([^/]+)$"):gsub("%.git$", "")

		local ok, mod = pcall(require, clean_name)

		if not ok then
			ok, mod = pcall(require, spec.name)
		end

		if ok and type(mod) == "table" and mod.setup then
			mod.setup(spec.opts)
		end
	end

	if type(spec.config) == "function" then
		spec.config(spec, spec.opts or {})
	end
end

local function apply_keymaps()
	local wk_ok, wk = pcall(require, "which-key")

	for _, plugin in ipairs(all_native_specs) do
		if plugin.keys then
			for _, key in ipairs(plugin.keys) do
				local lhs, rhs = key[1], key[2]
				local mode = key.mode or "n"

				vim.keymap.set(mode, lhs, rhs, { desc = key.desc })
			end
		end
	end
end

apply_keymaps()
