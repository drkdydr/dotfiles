return {
    -- 1. nvim-ufo (Katlama mantığı)
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = function()
            -- Katlama seçenekleri
            vim.o.foldcolumn = '1' -- Sol tarafta katlama sütununu aç
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            require('ufo').setup()
        end
    },
    -- 2. statuscol (Oklar ve şık görünüm)
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            vim.opt.fillchars = {
            fold = " ",        -- Katlanmış yerin devamındaki boşluk karakteri
            foldopen = "",    -- Açık olduğunda görünecek ok (Nerd Font gerektirir)
            foldsep = " ",     -- Ayırıcı
            foldclose = "",   -- Kapalı olduğunda görünecek ok
            }
            vim.o.foldcolumn = '1' -- '0' ise oklar görünmez, en az '1' olmalı.
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                relculright = true,
                segments = {
                    { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
                    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                },
            })
        end,
    },
}
