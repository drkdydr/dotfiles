return {
    {
    "nvim-tree/nvim-tree.lua",
    config = function()
        vim.keymap.set('n', '<leader>e',"<cmd>NvimTreeToggle<CR>", {desc = "Toggle [E]xplorer"})
        require("nvim-tree").setup({
            filters = {
                dotfiles = false, -- do not hide dotfiles
                -- custom = { ".DS_Store" }, -- hide special files if you want
              },
              git = {
                ignore = false, -- do not hide gitignored files
              },
            hijack_netrw = true,
            auto_reload_on_write = true,
        })
    end
    },
    {
        "nvim-tree/nvim-web-devicons",
    }
}
