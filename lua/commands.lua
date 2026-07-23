vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

-- Pack Delete and Update cmds are built-in on Nightly 0.13
vim.api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	if #opts.fargs > 0 then
		vim.pack.update(opts.fargs)
	else
		vim.pack.update()
	end
end, { nargs = "*", desc = "Update all plugins or specific ones" })

vim.api.nvim_create_user_command("MasonLock", function()
	local n = require("modules.mason-lock").snapshot()
	vim.notify(("Wrote %d packages to mason-lock.json"):format(n))
end, { desc = "Snapshot installed mason packages to mason-lock.json" })

vim.api.nvim_create_user_command("TSLock", function()
	local n = require("modules.treesitter-lock").snapshot()
	vim.notify(("Wrote %d parsers to treesitter-lock.json"):format(n))
end, { desc = "Snapshot installed treesitter parsers to treesitter-lock.json" })
