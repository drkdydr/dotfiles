return {
    "nvim-lualine/lualine.nvim",
    -- İkonların görünmesi için daha önce kurduğumuz devicons eklentisini istiyor
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                -- 'auto' seçeneği, Lualine'ın senin 'spacemanspiff' temanın 
                -- renklerini okuyup ona göre otomatik renklenmesini sağlar
                theme = "auto",
                
                -- Görseldeki o havalı ok/üçgen şeklindeki ayırıcılar
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                
                -- İkonları aktif et
                icons_enabled = true,
            },
            -- Hangi bölümde neyin görüneceğini ayarlıyoruz (A, B, C sol taraf; X, Y, Z sağ taraf)
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        })
    end
}
