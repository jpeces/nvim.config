-- Snapshot and restore mason package versions to/from mason-lock.json
local M = {}

local lock_path = vim.fn.stdpath("config") .. "/mason-lock.json"
local restoring = false
local registry = require("mason-registry")
local uv = vim.uv

function M.snapshot()
	local names = registry.get_installed_package_names()
	table.sort(names)
	local parts = {}
	for _, name in ipairs(names) do
		local ok, pkg = pcall(registry.get_package, name)
		if ok then
			local version = pkg:get_installed_version()
			if version then
				parts[#parts + 1] = vim.json.encode(name) .. ": " .. vim.json.encode(version)
			end
		end
	end

	local content = #parts == 0 and "{}\n" or "{\n  " .. table.concat(parts, ",\n  ") .. "\n}\n"
	local fd = uv.fs_open(lock_path, "w", 432)
	if fd then
		uv.fs_write(fd, content, -1)
		uv.fs_close(fd)
	end
	return #parts
end

function M.restore()
	if not uv.fs_stat(lock_path) then
		registry.refresh(function()
			if #registry.get_installed_package_names() > 0 then
				M.snapshot()
			end
		end)
		return
	end

	local ok, lock = pcall(vim.json.decode, table.concat(vim.fn.readfile(lock_path), "\n"))
	if not ok or type(lock) ~= "table" then
		return
	end

	registry.refresh(function()
		local pending = {}
		for name, version in pairs(lock) do
			local pkg_ok, pkg = pcall(registry.get_package, name)
			if pkg_ok and (not pkg:is_installed() or pkg:get_installed_version() ~= version) then
				pending[#pending + 1] = { pkg = pkg, version = version }
			end
		end

		if #pending == 0 then
			return
		end

		restoring = true
		local remaining, all_ok = #pending, true

		vim.notify(("mason-lock: installing %d packages from lock"):format(#pending))

		local function on_complete(success)
			if not success then
				all_ok = false
			end
			remaining = remaining - 1
			if remaining == 0 then
				restoring = false
				if all_ok then
					vim.notify(("mason-lock: installed %d packages from lock"):format(#pending))
				else
					vim.notify(
						"mason-lock: some packages failed to install, will retry next startup",
						vim.log.levels.WARN
					)
				end
			end
		end

		for _, target in ipairs(pending) do
			local install_ok = pcall(target.pkg.install, target.pkg, { version = target.version }, on_complete)
			if not install_ok then
				on_complete(false)
			end
		end
	end)
end

function M.init()
	local function on_change()
		if not restoring then
			M.snapshot()
		end
	end

	registry:on("package:install:success", on_change)
	registry:on("package:uninstall:success", on_change)
	M.restore()
end

return M
