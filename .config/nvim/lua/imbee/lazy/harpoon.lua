return {
    'ThePrimeagen/harpoon',
    branch = "master",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        -- Key mappings
        vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Add file to Harpoon' })
        vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
        vim.keymap.set('n', '<leader>h', function() ui.nav_file(1) end)
        vim.keymap.set('n', '<leader>t', function() ui.nav_file(2) end)
        vim.keymap.set('n', '<leader>n', function() ui.nav_file(3) end)
    end
}

