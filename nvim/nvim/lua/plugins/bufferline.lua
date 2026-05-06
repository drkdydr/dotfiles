return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local bufferline = require('bufferline')
        vim.opt.mousemoveevent = true

        bufferline.setup({
          
            options = {
                mode = "buffers",
                separator_style = "slant", --white triangles exist because of transparency in colorscheme (for slant)
                
                -- 1. NvimTree'nin üstünü boş bırak ve "File Explorer" yaz
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center", -- Dilersen "left" yapabilirsin
                        separator = true
                    }
                },

                -- 2. Çarpı işaretlerini normalde gizle
                show_buffer_close_icons = true,
                show_close_icon = true,

                -- 3. Sadece fareyle sekmenin üzerine gelince (hover) çarpıyı göster
                hover = {
                    enabled = true, 
                    delay = 10,
                    reveal = {'close'}
                },

                indicator = {
                    style = 'icon',
                    icon = '▎', 
                },
                modified_icon = '●', 
                color_icons = true, 
                always_show_bufferline = true,
            },

            
        })
    end
}
