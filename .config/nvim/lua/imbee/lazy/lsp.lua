return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			local ts_hints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			}

			local function lua_root(bufnr)
				local home = vim.uv.os_homedir()
				local name = vim.api.nvim_buf_get_name(bufnr)
				local config = vim.fn.stdpath("config")

				if vim.startswith(name, config .. "/") then
					return config
				end

				local root = vim.fs.root(bufnr, {
					".luarc.json",
					".luarc.jsonc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				})
				if root and root ~= home then
					return root
				end

				local dir = vim.fs.dirname(name)
				if dir ~= home then
					return dir
				end
			end

			local servers = {

				lua_ls = {
					root_dir = function(bufnr, on_dir)
						local root = lua_root(bufnr)
						if root then
							on_dir(root)
						end
					end,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "it", "describe", "before_each", "after_each" },
							},
							hint = {
								enable = true,
								paramName = "All",
								paramType = true,
								setType = true,
								arrayIndex = "Disable",
								semicolon = "Disable",
							},
						},
					},
				},

				bashls = {},

				basedpyright = {
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							analysis = {
								typeCheckingMode = "standard",
								inlayHints = {
									variableTypes = true,
									callArgumentNames = true,
									functionReturnTypes = true,
									genericTypes = false,
								},
							},
						},
					},
				},
				ruff = {},

				sqls = {},

				gopls = {
					settings = {
						gopls = {
							hints = {
								parameterNames = true,
								assignVariableTypes = true,
								rangeVariableTypes = true,
								compositeLiteralFields = false,
								compositeLiteralTypes = false,
								constantValues = false,
								functionTypeParameters = false,
							},
						},
					},
				},

				clangd = {
					root_markers = { ".clang-format", ".git", "compile_commands.json", "CMakeLists.txt" },
				},

				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
							inlayHints = {
								parameterHints = { enable = true },
								typeHints = { enable = true },
								chainingHints = { enable = true },
							},
						},
					},
				},

				hls = {},

				omnisharp = {
					settings = {
						RoslynExtensionsOptions = {
							InlayHintsOptions = {
								EnableForParameters = true,
								ForLiteralParameters = true,
								ForIndexerParameters = true,
								ForObjectCreationParameters = true,
								ForOtherParameters = true,
								EnableForTypes = true,
								ForImplicitVariableTypes = true,
								ForLambdaParameterTypes = true,
								ForImplicitObjectCreation = true,
							},
						},
					},
				},

				ts_ls = {
					settings = {
						typescript = { inlayHints = ts_hints },
						javascript = { inlayHints = ts_hints },
					},
				},

				html = {},
				cssls = {},
			}

			for name, cfg in pairs(servers) do
				vim.lsp.config(name, cfg)
			end
			vim.lsp.enable(vim.tbl_keys(servers))

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"bashls",
					"basedpyright",
					"ruff",
					"sqls",
					"gopls",
					"ts_ls",
					"html",
					"cssls",
					"clangd",
				},
				automatic_enable = false,
			})

			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
				callback = function(ev)
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
					end
					map("<F2>", vim.lsp.buf.rename, "Rename")
					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gr", vim.lsp.buf.references, "References")

					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			vim.lsp.inlay_hint.enable(true)
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle inlay hints" })

			local function set_hint_hl()
				vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
			end
			set_hint_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hint_hl })
		end,
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = false, lsp_format = "fallback" })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				cs = { "csharpier" },
			},
		},
	},
}
