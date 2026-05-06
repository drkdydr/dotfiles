-- this mapleaders must be declared before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.cmd("colorscheme spacemanspiff")

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
