function ColorMyPencils(color)
    color = color or "teide-darker" -- "tokyodark" -- "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true,     -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    -- comments = { italic = false },
                    -- keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
            })

            ColorMyPencils()
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
            })

            vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
        end
    },
    {
        "tiagovla/tokyodark.nvim",
        opts = {
            -- custom options here
        },
        config = function(_, opts)
            local default_config = {
                transparent_background = true, -- set background to transparent
                gamma = 1.00, -- adjust the brightness of the theme
                styles = {
                    comments = { italic = true }, -- style for comments
                    keywords = { italic = true }, -- style for keywords
                    identifiers = { italic = true }, -- style for identifiers
                    functions = {}, -- style for functions
                    variables = {}, -- style for variables
                },
                custom_highlights = {} or function(highlights, palette) return {} end, -- extend highlights
                custom_palette = {} or function(palette) return {} end, -- extend palette
                terminal_colors = true, -- enable terminal colors
            }

            require("tokyodark").setup(default_config) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]

            ColorMyPencils()
        end,
    },
    { 'kepano/flexoki-neovim', name = 'flexoki' },
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
    { "serhez/teide.nvim", lazy = false, priority = 1000, opts = {}, }
}
