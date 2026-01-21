local function insert_plugin(tabl, plugin)
	table.insert(tabl, {
		src = plugin.src,
		as = plugin.as or plugin.name or nil,
		version = (plugin.tag and plugin.tag ~= "*") and plugin.tag or nil,
		data = {
			build = plugin.build,
		},
		opts = plugin.opts,
		keys = plugin.keys,
		config = plugin.config
	})
end
local function merge_tables(a, b)
	local result = {}

	for k, v in pairs(a) do
		result[k] = v
	end

	for k, v in pairs(b) do
		result[k] = v
	end

	return result
end

-- 1. Hook for builds
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local spec = ev.data.spec
		if (ev.data.kind == 'install' or ev.data.kind == 'update') and spec.data and spec.data.build then
			print("Building: " .. spec.as)
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

	for _, plugin in ipairs(list) do
		local src = type(plugin) == "string" and { src = plugin } or plugin
		plugin.src = src.src or src[1]
		if not plugin.priority then
			plugin.priority = 100
		end

		if plugin.src and not seen_plugins[plugin.src] then
			seen_plugins[plugin.src] = true -- Mark as handled
			if not plugin.src:match("://") and not plugin.src:match("git@") then
				plugin.src = "https://github.com/" .. plugin.src
			end

			if plugin.deps and type(plugin.deps) == "table" then
				for _, d in pairs(plugin.deps) do
					parse_and_collect(d)
				end
			end
			insert_plugin(all_native_specs, plugin)
		elseif plugin.src then
			local k = merge_tables(seen_plugins[plugin.src].keys, plugin.keys)
			local o = merge_tables(seen_plugins[plugin.src].opts, plugin.opts)
			local mp = merge_tables(seen_plugins[plugin.src], plugin)
			mp.keys = k
			mp.opts = o
			insert_plugin(all_native_specs, mp)
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
	table.sort(all_native_specs, function(a, b)
		-- Handle cases where priority might be missing (default to 0 or 999)
		local prio_a = a.priority or 0
		local prio_b = b.priority or 0

		return prio_a > prio_b -- Returns true if 'a' should come before 'b'
	end)
	vim.pack.add(all_native_specs)
end
local function sync_plugin_names(tbl_a)
	-- 1. Fetch all installed plugin data
	local installed_plugins = vim.pack.get()

	-- 2. Iterate through your target table (Table A)
	for _, entry in ipairs(tbl_a) do
		-- 3. Iterate through installed plugins to find a source match
		for _, info in pairs(installed_plugins) do
			if entry.as ~= nil then
				break
			end
			local installed_src = info.spec.src

			-- 4. If the source URLs match, update the name in Table A
			if installed_src and installed_src == entry.src then
				entry.as = info.spec.name
				break -- Match found for this entry, move to next
			end
		end
	end
end

sync_plugin_names(all_native_specs)
for _, plugin in pairs(all_native_specs) do
	if plugin.config then
		plugin.config()
	end
	-- vim.print(plugin.as)
	local ok, mod = pcall(require, plugin.as)
	if plugin.opts and ok then
		mod.setup(plugin.opts)
	end
	if plugin.install and ok then
		mod.install(plugin.install)
	end
end

local function apply_keymaps()
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
