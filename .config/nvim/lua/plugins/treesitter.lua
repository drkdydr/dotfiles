return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag"
    },
    config = function()
        -- pcall (protected call) ile eklentiyi güvenli bir şekilde çağırıyoruz
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        
        -- Eğer eklenti henüz diske inmemişse çökme, sessizce çık
        if not status_ok then
            return
        end

        configs.setup({
            ensure_installed = {
                "vim", "vimdoc", "lua", "c", "cpp", "java", "javascript", 
                "typescript", "html", "css", "json", "tsx", "markdown", 
                "markdown_inline", "gitignore"
            },
            highlight = { enable = true },
            autotag = { enable = true },
        })
    end
}
