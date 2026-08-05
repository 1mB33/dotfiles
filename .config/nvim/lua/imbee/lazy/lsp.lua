return {
    "neovim/nvim-lspconfig",
    dependencies = {
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
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("fidget").setup({})

        vim.lsp.config.lua_ls = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                },
            },
        }

        vim.lsp.config.clangd = {
            capabilities = capabilities,
            root_markers = { ".clang-format", ".git", "compile_commands.json", "CMakeLists.txt" },
        }

        vim.lsp.config.rust_analyzer = {
            capabilities = capabilities,
            cmd = { "rust-analyzer" },
            filetypes = { "rust" },
            root_markers = { "Cargo.toml", ".git" },
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = { command = "clippy" },
                },
            },
        }
        vim.lsp.config.hls = {
            capabilities = capabilities,
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
            capabilities = capabilities,
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
            capabilities = capabilities,
        }

        vim.lsp.config.ts_ls = {
            capabilities = capabilities,
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
            },
            root_markers = {
                "package.json",
                "tsconfig.json",
                "jsconfig.json",
                ".git",
            },
        }

        vim.lsp.config.html = {
            capabilities = capabilities,
            cmd = { "vscode-html-language-server", "--stdio" },
            filetypes = { "html" },
        }

        vim.lsp.config.cssls = {
            capabilities = capabilities,
            cmd = { "vscode-css-language-server", "--stdio" },
            filetypes = {
                "css",
                "scss",
                "less",
            },
        }

        vim.lsp.config.jsonls = {
            capabilities = capabilities,
            cmd = { "vscode-json-language-server", "--stdio" },
            filetypes = { "json", "jsonc" },
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
            "ts_ls",
            "html",
            "cssls",
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
