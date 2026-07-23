-- Snapshot and restore treesitter parser set to/from treesitter-lock.json.
-- Unlike mason-lock, no versions are stored: nvim-treesitter pins parser
-- commits internally via its own lockfile. This lock only captures the SET
-- of installed parsers so a fresh machine reproduces it.
local M = {}

local lock_path = vim.fn.stdpath("config") .. "/treesitter-lock.json"
local restoring = false

function M.snapshot()
	local installed = require("nvim-treesitter").get_installed()
	table.sort(installed)
	local uv = vim.uv
	local fd = uv.fs_open(lock_path, "w", 432)
	if fd then
		uv.fs_write(fd, vim.json.encode(installed, { indent = "  " }), -1)
		uv.fs_close(fd)
	end
	return #installed
end

function M.restore()
	local uv = vim.uv
	if not uv.fs_stat(lock_path) then
		M.snapshot()
		return
	end

	local ok, lock_arr = pcall(vim.json.decode, table.concat(vim.fn.readfile(lock_path), "\n"))
	if not ok or type(lock_arr) ~= "table" then
		return
	end

	-- Find parsers in the lock that are not yet installed.
	-- install() already no-ops on installed parsers, but this lets us
	-- skip the install call entirely and notify accurately when there
	-- is nothing to do.
	local installed = {}
	for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
		installed[lang] = true
	end
	local pending = {}
	for _, lang in ipairs(lock_arr) do
		if not installed[lang] then
			pending[#pending + 1] = lang
		end
	end

	if #pending == 0 then
		return
	end

	restoring = true
	vim.notify(("treesitter-lock: installing %d parsers from lock"):format(#pending))

	local task = require("nvim-treesitter").install(pending)
	task:await(function(err, success)
		restoring = false
		if err then
			vim.notify("treesitter-lock: restore failed", vim.log.levels.WARN)
			return
		end
		if success then
			M.snapshot()
			vim.notify(("treesitter-lock: installed %d parsers from lock"):format(#pending))
		else
			vim.notify("treesitter-lock: some parsers failed to install, will retry next startup", vim.log.levels.WARN)
		end
	end)
end

function M.init()
	-- nvim-treesitter has no install/uninstall events (unlike mason's
	-- registry:on("package:install:success")). To auto-snapshot on every
	-- install/uninstall, we wrap the module functions.
	--
	-- This catches :TSInstall and :TSUninstall too: those commands call
	-- require("nvim-treesitter.install").install(...) at invocation time
	-- (not at definition time), so they resolve to our wrapped function,
	-- not a captured reference. See plugin/nvim-treesitter.lua in the
	-- plugin source.
	--
	-- install() and uninstall() return async Task objects (from a.async).
	-- Task:await(callback) fires callback(err, result) on completion,
	-- non-blocking. Multiple :await calls on the same Task accumulate
	-- multiple callbacks, so both the wrap's callback and any caller's
	-- callback (e.g. restore()) fire on completion.
	--
	-- The `restoring` flag prevents restore()'s own install call from
	-- re-snapshotting mid-restore: the wrap's callback checks `restoring`
	-- and skips when true. restore()'s callback resets the flag after
	-- handling the result.
	local install_mod = require("nvim-treesitter.install")
	for _, name in ipairs({ "install", "uninstall" }) do
		local orig = install_mod[name]
		install_mod[name] = function(...)
			local task = orig(...)
			task:await(function(err)
				if not err and not restoring then
					M.snapshot()
				end
			end)
			return task
		end
	end
	M.restore()
end

return M
