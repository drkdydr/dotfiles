return {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup({
                  comment_empty = false;
            })

            -- Ctrl + / shortcut for comment toggle
            local opts = { noremap = true, silent = true }
            vim.keymap.set('n', '<leader>cc', ':CommentToggle<CR>', opts)
            vim.keymap.set('v', '<leader>cc', ':CommentToggle<CR>', opts)
        end
}
