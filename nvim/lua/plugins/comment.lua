return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			-- Eklentiye C++ için ne kullanacağını pre_hook ile zorla öğretiyoruz:
			pre_hook = function(ctx)
				-- Eğer dosya C veya C++ ise doğrudan yorum karakterini dön
				if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
					return "// %s"
				end
			end,
		})
	end,
	lazy = false,
}
