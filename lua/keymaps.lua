vim.g.mapleader = " "
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

vim.keymap.set("n", "<leader>d", [["_dd]], { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Moves lines down in visual selection" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

-- lsp --
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- tab stuff --
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")     -- go to next
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")     -- go to pre
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>") -- open current tab in new tab

vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")

vim.cmd.packadd("nohlsearch")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word cursor is on globally" })
-- vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- native undotree --
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
    -- Calculate 1/3 of the current active window width
    local third_width = math.floor(vim.api.nvim_win_get_width(0) / 3)

    require("undotree").open({ command = third_width.. "vnew"})
end, { desc = "Toggle Builtin Undotree" })

-- restart --
vim.keymap.set("n", "<leader>r", "<cmd>restart<cr>", { desc = "Restart config (:restart)" })

vim.keymap.set("n", "<leader>lr", function()
    vim.cmd("lsp restart")
    vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })

-- mini.files --
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
    require("mini.files").reveal_cwd()
end, { desc = "Toggle into currently opened file" })

-- mini.pick --
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })
vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>pd", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, { desc = "Search references" })

-- vim-fugitive --
vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })


-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

local term_buf
vim.keymap.set("n", "<leader>t", function()
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        local win = vim.fn.bufwinid(term_buf)
        if win ~= -1 then
            vim.api.nvim_win_close(win, true)
            return
        end
        vim.cmd("botright 12new")
        vim.cmd("buffer " .. term_buf)
        vim.wo.winfixheight = true
        vim.cmd.startinsert()
        return
    end

    vim.cmd("botright 12new")
    vim.cmd.term()
    term_buf = vim.api.nvim_get_current_buf()
    vim.wo.winfixheight = true
    vim.cmd.startinsert()
end, { desc = "Toggle bottom terminal" })

