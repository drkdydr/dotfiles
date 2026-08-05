return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- Build zaten manuel yapıldığı için bu satırı değiştirebilir veya silebilirsin
    build = "cd app && npm install", 
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
        -- Zen Browser Ayarı
        -- Fedora'da genellikle 'zen' komutuyla çalışır. 
        -- Eğer çalışmazsa 'zen-browser' yapmayı dene.
        vim.g.mkdp_browser = "firefox" 

        -- Genel Ayarlar
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_theme = "dark"
        
        -- Görselleştirme
        vim.g.mkdp_preview_options = {
            mkit = {}, katex = {}, uml = {}, maid = {},
            disable_sync_scroll = 0,
            sync_scroll_type = "middle",
            hide_yaml_meta = 1,
        }
    end,
}
