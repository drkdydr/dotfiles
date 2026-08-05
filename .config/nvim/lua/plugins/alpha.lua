return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  opts = function()

    local dashboard = require("alpha.themes.dashboard")

    local logo = [[
 ██████   █████ ██████████    ███████    █████   █████ █████ ██████   ██████
▒▒██████ ▒▒███ ▒▒███▒▒▒▒▒█  ███▒▒▒▒▒███ ▒▒███   ▒▒███ ▒▒███ ▒▒██████ ██████ 
 ▒███▒███ ▒███  ▒███  █ ▒  ███     ▒▒███ ▒███    ▒███  ▒███  ▒███▒█████▒███ 
 ▒███▒▒███▒███  ▒██████   ▒███      ▒███ ▒███    ▒███  ▒███  ▒███▒▒███ ▒███ 
 ▒███ ▒▒██████  ▒███▒▒█   ▒███      ▒███ ▒▒███   ███   ▒███  ▒███ ▒▒▒  ▒███ 
 ▒███  ▒▒█████  ▒███ ▒   █▒▒███     ███   ▒▒▒█████▒    ▒███  ▒███      ▒███ 
 █████  ▒▒█████ ██████████ ▒▒▒███████▒      ▒▒███      █████ █████     █████
▒▒▒▒▒    ▒▒▒▒▒ ▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒         ▒▒▒      ▒▒▒▒▒ ▒▒▒▒▒     ▒▒▒▒▒ 
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    -- stylua: ignore

    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
      dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
      dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
      dashboard.button("c", " " .. " Config",          "<cmd> cd ~/.config/nvim <BAR> Telescope find_files <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8

    return dashboard

  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    -- Logoyu mor yap (#b16286 veya istediğin bir hex kodu)
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ade2f7", bold = true })
    
    -- Buton yazılarını turuncu yap
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#8dcee8" })
    
    -- Kısayol tuş harflerini (f, n, q gibi) camgöbeği yap
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ade2f7", bold = true })

    -- Alt kısımdaki yüklenme süresi yazısını gri/mavi bir tona ve eğik (italic) fonta ayarla
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#4c4c4c", italic = true })

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = "Hayatta en hakiki mürşit, ilimdir."
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
