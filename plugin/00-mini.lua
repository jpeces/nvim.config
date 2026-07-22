vim.pack.add({
    'https://github.com/nvim-mini/mini.icons',
    'https://github.com/nvim-mini/mini.completion',
    'https://github.com/nvim-mini/mini.pick',
    'https://github.com/sh1Nome/mini-pick-preview.nvim',
    'https://github.com/nvim-mini/mini.extra',
    'https://github.com/nvim-mini/mini.surround',
    'https://github.com/nvim-mini/mini.cmdline',
    'https://github.com/nvim-mini/mini.notify',
    'https://github.com/nvim-mini/mini.diff',
    'https://github.com/nvim-mini/mini.snippets',
    'https://github.com/nvim-mini/mini.files',
    'https://github.com/nvim-mini/mini.trailspace',
})

-- mini.icons
require('mini.icons').setup()

-- mini.completion
require('mini.completion').setup({ lsp_completion = { auto_setup = true } })

-- mini.pick
require('mini.pick').setup()

-- mini-pick-preview.nvim
require('mini-pick-preview').setup()

-- mini.extra
require('mini.extra').setup()

-- mini.surround
require('mini.surround').setup()

-- mini.cmdline
require('mini.cmdline').setup({ autocorrect = { enable = false } })

-- mini.notify
require('mini.notify').setup({ content = { format = function(notif) return notif.msg end } })

-- mini.diff
require('mini.diff').setup()

-- mini.snippets
local snip = require('mini.snippets')
snip.setup({ snippets = { snip.gen_loader.from_lang() } })
snip.start_lsp_server({ match = false })

-- mini.files
local files = require('mini.files')
files.setup({ mappings = { go_in = '<CR>' } })
vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf = args.data.buf_id
        for _, m in ipairs({
            { '<C-s>', 'belowright horizontal' },
            { '<C-l>', 'belowright vertical' },
            { '<C-t>', 'tab' },
        }) do
            local lhs, dir = m[1], m[2]
            vim.keymap.set('n', lhs, function()
                local cur = files.get_explorer_state().target_window
                local new = vim.api.nvim_win_call(cur, function()
                    vim.cmd(dir .. ' split')
                    return vim.api.nvim_get_current_win()
                end)
                files.set_target_window(new)
                files.go_in()
            end, { buffer = buf, desc = 'Open in ' .. dir .. ' split' })
        end
    end,
})

-- mini.trailspace
local ts = require('mini.trailspace')
ts.setup({ only_in_normal_buffers = true })
vim.api.nvim_create_autocmd('BufWritePost', { pattern = '*', callback = function() ts.trim() end })
vim.api.nvim_create_autocmd('CursorMoved', { pattern = '*', callback = function() ts.unhighlight() end })
