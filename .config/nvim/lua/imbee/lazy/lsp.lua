return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "stevearc/conform.nvim",
    },
    config = function()
        local cmp = require('cmp')

        require("fidget").setup({})
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "rust_analyzer",
            },
        })

        vim.lsp.config.lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                },
            },
        }

        vim.lsp.config.clangd = {
            root_markers = { ".clang-format", ".git", "compile_commands.json", "CMakeLists.txt" },
        }

        vim.lsp.config.rust_analyzer = {}

        vim.lsp.config.hls = {
            cmd = { "haskell-language-server-wrapper", "--lsp" },
            filetypes = { "haskell", "lhaskell" },
            root_markers = {
                "cabal.project",
                "stack.yaml",
                "package.yaml",
                ".git",
            },
        }

        vim.lsp.config.pylsp = {
            settings = {
                pylsp = {
                    plugins = {
                        black = { enabled = true },
                        autopep8 = { enabled = false },
                        yapf = { enabled = false },
                    },
                },
            },
        }

        vim.lsp.config.omnisharp = {
            capabilities = {
                documentFormattingProvider = false,
            },
        }

        require("conform").setup({
            formatters_by_ft = {
                cs = { "csharpier" },
            },
        })

        vim.lsp.enable({
            "lua_ls",
            "clangd",
            "rust_analyzer",
            "hls",
            "pylsp",
            "pyright",
            "omnisharp",
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                -- ['<tab>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end)
        vim.keymap.set("n", "<leader>f", function()
            if not vim.lsp.buf.format({ async = false }) then
                require("conform").format({ async = false })
            end
        end)
    end

}
