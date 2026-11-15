return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        config = function ()
            vim.keymap.set('n', '<leader>pv', ':Neotree float<CR>', { noremap = true, silent = true })
            require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                    hijack_netrw_behavior = "disabled", -- important
                },
            })
        end,
        lazy = false, -- neo-tree will lazily load itself
        opts = {
        },
    }
}
