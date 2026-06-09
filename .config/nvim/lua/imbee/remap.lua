vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-f>", "<cmd>q<CR>")
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

vim.keymap.set('n', '<leader>c', function()
    local upTo = 120
    local col = vim.fn.col('.')
    local line = vim.api.nvim_get_current_line()
    local fill_len = upTo - col - 3  -- 3 for "// "
    if fill_len < 0 then
        fill_len = 0
    end
    local new_line = line:sub(1, col-1) .. "// " .. string.rep("-", fill_len)
    vim.api.nvim_set_current_line(new_line)
end, { noremap = true, silent = true })
