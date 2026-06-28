return {
    "folke/which-key.nvim",
    event = 'VimEnter',

    config = function()
        local status_ok, which_key = pcall(require, "which-key")
        if not status_ok then
            return
        end

        -- 1. ADIM: Güncellenmiş Setup Ayarları
        local setup = {

            triggers = {
                { "<auto>", mode = "nxs" }, -- Varsayılan olan "nxso" içinden "o" harfini (Operator-pending mode) çıkardık.
            },

            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
                presets = {
                    operators = false,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
            },
            keys = {
                scroll_down = "<c-d>", -- eski 'popup_mappings' yerine 'keys'
                scroll_up = "<c-u>",
            },
            win = { -- eski 'window' yerine 'win'
                border = "rounded",
                padding = { 2, 2, 2, 2 },
            },
            layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 3,
                align = "left",
            },
            -- Kullanımdan kalkan (hidden, ignore_missing, triggers_blacklist vb.)
            -- ayarlar temizlendi çünkü v3 bunları otomatik ve daha iyi yönetiyor.
        }

        which_key.setup(setup)

        -- 2. ADIM: Yeni Eşleme (Mapping) Formatı
        which_key.add({

            { "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha", nowait = true, remap = false },

            { "<leader>b", group = "Debugger" },
            { "<leader>bt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint", nowait = true, remap = false },
            { "<leader>bc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue", nowait = true, remap = false },
            { "<leader>bi", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into", nowait = true, remap = false },
            { "<leader>bo", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over", nowait = true, remap = false },
            { "<leader>bu", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out", nowait = true, remap = false },
            { "<leader>br", "<cmd>lua require'dap'.repl.open()<cr>", desc = "Open REPL", nowait = true, remap = false },
            { "<leader>bl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Run Last", nowait = true, remap = false },
            { "<leader>bq", "<cmd>lua require'dap'.terminate(); require'dapui'.close(); require'nvim-dap-virtual-text'.toggle()<cr>", desc = "Terminate", nowait = true, remap = false },
            { "<leader>bb", "<cmd>lua require'dap'.list_breakpoints()<cr>", desc = "List Breakpoints", nowait = true, remap = false },
            { "<leader>be", "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<cr>", desc = "Set Exception Breakpoints", nowait = true, remap = false },
            { "<leader>bX", "<cmd>lua require'dap'.clear_breakpoints()<cr>", desc = "Clear All Breakpoints", nowait = true, remap = false },

            { "<leader>c", group = "Code/Change" }, -- 'c' tuşuna basınca bu grup adı gözükür
            { "<leader>cr", desc = "Smart Rename" },

            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = true, remap = false },

            { "<leader>f", group = "File Search", nowait = true, remap = false },
            { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme", nowait = true, remap = false },
            { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files", nowait = true, remap = false },
            { "<leader>fg", "<cmd>Telescope live_grep <cr>", desc = "Find Text Pattern", nowait = true, remap = false },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files", nowait = true, remap = false },

            { "<leader>g", group = "Git / VGit" },
  
            -- Normal mod ('n') için alt tuş atamaları
            { "<leader>gs", function() require('vgit').buffer_hunk_stage() end, desc = "Hunk Stage", mode = "n" },
            { "<leader>gr", function() require('vgit').buffer_hunk_reset() end, desc = "Hunk Reset", mode = "n" },
            { "<leader>gp", function() require('vgit').buffer_hunk_preview() end, desc = "Hunk Preview", mode = "n" },
            { "<leader>gb", function() require('vgit').buffer_blame_preview() end, desc = "Blame Preview", mode = "n" },
            { "<leader>gf", function() require('vgit').buffer_diff_preview() end, desc = "Buffer Diff Preview", mode = "n" },
            { "<leader>gh", function() require('vgit').buffer_history_preview() end, desc = "Buffer History", mode = "n" },
            { "<leader>gu", function() require('vgit').buffer_reset() end, desc = "Buffer Reset", mode = "n" },
            { "<leader>gd", function() require('vgit').project_diff_preview() end, desc = "Project Diff Preview", mode = "n" },
            { "<leader>gx", function() require('vgit').toggle_diff_preference() end, desc = "Toggle Diff Preference", mode = "n" },

            { "<leader>k", "<cmd>bdelete<CR>", desc = "Kill Buffer", nowait = true, remap = false },

            { "<leader>l", group = "LSP", nowait = true, remap = false },
            { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols", nowait = true, remap = false },
            { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
            { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", nowait = true, remap = false },
            { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", nowait = true, remap = false },

            { "<leader>m", group = "Markdown Prewiew" },
            { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Preview", nowait = true, remap = false },
            { "<leader>ms", "<cmd>MarkdownPreview<cr>", desc = "Start Preview", nowait = true, remap = false },
            { "<leader>mS", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Preview", nowait = true, remap = false },

            { "<leader>M", "<cmd>Mason<cr>", desc = "Mason", nowait = true, remap = false },
            { "<leader>p", "<cmd>Lazy<CR>", desc = "Plugin Manager", nowait = true, remap = false },
            { "<leader>q", "<cmd>wqall!<CR>", desc = "Quit", nowait = true, remap = false },
            { "<leader>r", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Reformat Code", nowait = true, remap = false },

            { "<leader>s", group = "Search", nowait = true, remap = false },
            { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help", nowait = true, remap = false },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
            { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
            { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },

            { "<leader>t", group = "Terminal", nowait = true, remap = false },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", nowait = true, remap = false },
            { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal", nowait = true, remap = false },
            { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node", nowait = true, remap = false },
            { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python", nowait = true, remap = false },
            { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical", nowait = true, remap = false },
            
            -- NOT: Çakışmayı önlemek için <leader>w (Save) kısayolunu <leader>fs (File Save) 
            -- veya başka bir şeye taşıyabilirsin. Şimdilik orijinalini bıraktım.
            { "<leader>w", "<cmd>w!<CR>", desc = "Save", nowait = true, remap = false },
        })

    end
}
