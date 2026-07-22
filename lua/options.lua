-- vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true

-- indentation --
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.smartindent = true

-- search --
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- window splits -- 
vim.opt.splitbelow = true
vim.opt.splitright = true

-- backup and undo --
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- UI --
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "0"
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.laststatus = 3
vim.opt.termguicolors = true

-- misc -- 
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")
vim.opt.clipboard:append("unnamedplus")
vim.opt.isfname:append("@-@")

-- highlight yanking --
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})
