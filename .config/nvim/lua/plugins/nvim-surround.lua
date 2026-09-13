return {
      "kylechui/nvim-surround",
      version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
            -- disable default mapping
            vim.g.nvim_surround_no_normal_mappings = true 

                 -- Normal Mode Shortcuts
            vim.keymap.set("n", "<leader>Sa", "<Plug>(nvim-surround-normal)iw", {
                desc = "Add surrounding (normal mode)",
            })
            vim.keymap.set("n", "<leader>Sd", "<Plug>(nvim-surround-delete)", {
                desc = "Delete surrounding (normal mode)",
            })
            vim.keymap.set("n", "<leader>Sr", "<Plug>(nvim-surround-change)", {
                desc = "Replace surrounding (normal mode)",
            })
            vim.keymap.set("n", "<leader>Sl", "<Plug>(nvim-surround-normal-cur)", {
                desc = "Surround line inside same line",
            })
            vim.keymap.set("n", "<leader>SL", "<Plug>(nvim-surround-normal-cur-line)", {
                desc = "Surround line from upper & lower lines",
            })

            -- Visual Mode Shortcuts
            vim.keymap.set("x", "<leader>Sa", "<Plug>(nvim-surround-visual)", {
                desc = "Add surrounding (visual mode)",
            })
            vim.keymap.set("x", "<leader>Sl", "<Plug>(nvim-surround-visual-line)", {
                desc = "Surround selected lines",
            })

      end
}
