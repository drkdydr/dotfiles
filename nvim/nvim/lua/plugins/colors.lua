-- colors.lua
return {
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    transparent = true, -- Temel şeffaflık
                }
            })
            vim.cmd("colorscheme github_dark")
        end,    
    },
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        config = function()
            require('transparent').setup({
                -- Eklemek istediğin diğer eklenti grupları:
                extra_groups = {
                    "BufferLineFileIcon",
                    "BufferLineFill",
                    "BufferLineBackground",
                    "BufferLineSeparator",
                    "BufferLineIndicatorSelected",
                    "NvimTreeNormal",
                    "NvimTreeNormalNC",
                    "NvimTreeWinSeparator",
                },
                exclude_groups = {}, 
            })
        end
    }
}
