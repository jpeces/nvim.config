return {
    { "mason-org/mason.nvim" },

    { "nvim-treesitter/nvim-treesitter", config = function()
        local treesitter = require("nvim-treesitter")

        local ensure_installed = {
            "go", "rust", "typescript", "javascript", "tsx",
            "html", "css", "json", "bash",
            "http", "dockerfile",
        }
        treesitter.install(ensure_installed)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local buf, ft = args.buf, vim.bo[args.buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then return end
                if not pcall(vim.treesitter.language.add, lang) then return end
                pcall(vim.treesitter.start, buf, lang)
            end,
        })
    end },

    { "neovim/nvim-lspconfig", config = function()
        vim.diagnostic.config({ virtual_text = true })

        local capabilities = vim.tbl_deep_extend("force",
            vim.lsp.protocol.make_client_capabilities(),
            require("mini.completion").get_lsp_capabilities())
        vim.lsp.config("*", { capabilities = capabilities })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                },
            },
        })

        vim.lsp.enable({
            "lua_ls",
            "marksman",
            "rust_analyzer",
        })
    end },
}
