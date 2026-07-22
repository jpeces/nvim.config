return {
    { "nvim-mini/mini.surround" },
    { "nvim-mini/mini.icons" },
    { "nvim-mini/mini.pick" },
    { "nvim-mini/mini.extra" },

    { "nvim-mini/mini.cmdline", config = { autocorrect = { enable = false } } },
    {
        "nvim-mini/mini.notify",
        config = {
            content = {
                format = function(notif) return notif.msg end,
            },
        }
    },
    { "nvim-mini/mini.completion", config = { lsp_completion = { auto_setup = true } } },

    {
        "nvim-mini/mini.diff",
        config = function()
            local diff = require("mini.diff")
            diff.setup({ source = diff.gen_source.git({ index = false }) })
        end
    },

    {
        "nvim-mini/mini.snippets",
        config = function()
            local snip = require("mini.snippets")
            snip.setup({ snippets = { snip.gen_loader.from_lang() } })
            snip.start_lsp_server({ match = false })
        end
    },

    {
        "nvim-mini/mini.files",
        config = function()
            local files = require("mini.files")
            files.setup({ mappings = { go_in = "<CR>" } })
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf = args.data.buf_id
                    for _, m in ipairs({
                        { "<C-s>", "belowright horizontal" },
                        { "<C-l>", "belowright vertical" },
                        { "<C-t>", "tab" },
                    }) do
                        local lhs, dir = m[1], m[2]
                        vim.keymap.set("n", lhs, function()
                            local cur = files.get_explorer_state().target_window
                            local new = vim.api.nvim_win_call(cur, function()
                                vim.cmd(dir .. " split")
                                return vim.api.nvim_get_current_win()
                            end)
                            files.set_target_window(new)
                            files.go_in()
                        end, { buffer = buf })
                    end
                end,
            })
        end
    },

    {
        "nvim-mini/mini.trailspace",
        config = function()
            local ts = require("mini.trailspace")
            ts.setup({ only_in_normal_buffers = true })
            vim.keymap.set("n", "<leader>cw", function() ts.trim() end, { desc = "Erase whitespace" })
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = "*",
                callback = function() ts.trim() end,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                pattern = "*",
                callback = function() ts.unhighlight() end,
            })
        end,
    },
}
