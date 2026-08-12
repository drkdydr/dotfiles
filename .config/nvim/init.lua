-- this mapleaders must be declared before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd("colorscheme my")

-- Load the options from the config/options.lua file
require("config.options")

-- Load the keymaps from the config/keymaps.lua file
require("config.keymaps")

-- Load the auto commands from the config/autocmds.lua file
require("config.autocmds")

-- Load lazy configurations
require("lazy-setup")

-- Load lsp configurations
require("lsp")

-- GPT said this for white border for plugins
local hl = vim.api.nvim_set_hl

-- Standart yüzen pencere çerçevesini Telescope çerçevesine bağla
hl(0, "FloatBorder", { link = "TelescopeBorder" })

-- Standart yüzen pencere arka planını Telescope arka planına bağla
hl(0, "NormalFloat", { link = "TelescopeNormal" })

-- Eğer Which-Key veya Mason gibi eklentiler kendi gruplarını kullanıyorsa
-- onları da bu zincire ekleyebiliriz:
hl(0, "WhichKeyFloat", { link = "TelescopeNormal" })
hl(0, "MasonNormal", { link = "TelescopeNormal" })

vim.filetype.add({
  extension = {
    arb = "json",
  },
})

-- prevent the horizontal line between code area and nvim-tree
vim.opt.fillchars:append({
  vert = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " "
})

-- Tabline arka planlarını transparan yap
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })

-- Eğer akinsho/bufferline.nvim kullanıyorsan, eklentinin kendi grubunu da temizlemen gerekebilir:
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "NONE", ctermbg = "NONE"})

-- -- Make warning message background transparent
-- vim.api.nvim_set_hl(0, "WarningMsg", { fg = "#e2a15f", bg = "NONE", ctermbg = "NONE" })

-- -- Hata mesajlarının (ErrorMsg) da arka planını silmek istersen (isteğe bağlı):
-- -- Make warning message background transparent
-- vim.api.nvim_set_hl(0, "ErrorMsg", { fg = "#fa7970", bg = "NONE", ctermbg = "NONE" })
