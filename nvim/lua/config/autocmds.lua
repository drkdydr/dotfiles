vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = { "c", "cpp" },
  callback = function()
    -- Neovim'in dahili buffer ayarını değiştiriyoruz
    vim.bo.commentstring = "// %s"
    -- Eğer comment.nvim hâlâ inat ediyorsa, ona global olarak da dikte ediyoruz
    vim.g.commentstring = "// %s"
  end,
})
