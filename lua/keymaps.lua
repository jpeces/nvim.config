vim.g.mapleader = " "

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

vim.keymap.set("n", "<leader>d", [["_dd]], { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Moves lines down in visual selection" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Moves lines up in visual selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

-- lsp --
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- tabs --
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- window navigation --
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- window resize --
vim.keymap.set("n", "<M-=>", "<C-w>5>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-->", "<C-w>5<", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-t>", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<M-s>", "<C-w>-", { desc = "Decrease window height" })

vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit window" })

vim.cmd.packadd("nohlsearch")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)
-- vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- native undotree --
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
	local third_width = math.floor(vim.api.nvim_win_get_width(0) / 3)
	require("undotree").open({ command = third_width .. "vnew" })
end, { desc = "Toggle builtin undotree" })

-- restart --
vim.keymap.set("n", "<leader>r", "<cmd>restart<cr>", { desc = "Restart config" })
vim.keymap.set("n", "<leader>lr", function()
	vim.cmd("lsp restart")
	vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })

-- mini.trailspace --
vim.keymap.set("n", "<leader>cw", function()
	require("mini.trailspace").trim()
end, { desc = "Erase whitespace" })

-- mini.files --
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
	require("mini.files").reveal_cwd()
end, { desc = "Toggle into currently opened file" })

-- mini.pick --
vim.keymap.set("n", "<leader>pf", function()
	require("mini.pick").builtin.cli(
		{ command = { "rg", "--files", "--hidden", "--glob", "!.git", "--color=never" } },
		{ source = { name = "Files (rg)" } }
	)
end, { desc = "Mini file picker" })
vim.keymap.set("n", "<leader>ps", function()
	require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>vh", function()
	require("mini.pick").builtin.help()
end, { desc = "Help" })
vim.keymap.set("n", "<leader>xx", function()
	require("mini.extra").pickers.diagnostic()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>pk", function()
	require("mini.extra").pickers.keymaps()
end, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>pd", function()
	require("mini.extra").pickers.lsp({ scope = "document_symbol" })
end, { desc = "Search references" })

-- vim-fugitive --
vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive full page new tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })

-- terminal --
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local term_buf
vim.keymap.set("n", "<leader>t", function()
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		local win = vim.fn.bufwinid(term_buf)
		if win ~= -1 then
			if vim.api.nvim_get_current_win() == win then
				vim.api.nvim_win_close(win, true)
				return
			end
			vim.api.nvim_set_current_win(win)
			vim.cmd.startinsert()
			return
		end
	end

	vim.cmd("botright 12new")
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("buffer " .. term_buf)
	else
		vim.cmd.term()
		term_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(term_buf, "term:" .. vim.fn.jobpid(vim.b[term_buf].terminal_job_id))
	end
	vim.wo.winfixheight = true
	vim.cmd.startinsert()
end, { desc = "Toggle bottom terminal" })
