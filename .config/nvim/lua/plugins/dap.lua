return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")
        local mason_dap = require("mason-nvim-dap")
        local dap_virtual_text = require("nvim-dap-virtual-text")

        -- Inline variable display
        dap_virtual_text.setup()

        -- Debug adapter management
        mason_dap.setup({
            ensure_installed = { "cppdbg" }, -- MS C++ debugger
            automatic_installation = true,
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
        })

        -- Debugger UI setup
        ui.setup()

        -- Auto-toggle UI on debug events
        dap.listeners.before.attach.dapui_config = function() ui.open() end
        dap.listeners.before.launch.dapui_config = function() ui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
        dap.listeners.before.event_exited.dapui_config = function() ui.close() end

        -- Breakpoint icon
        vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint" })

        -- C++ / C configuration
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    -- Prompt for executable path
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                setupCommands = {
                    {
                        text = "-enable-pretty-printing",
                        description = "Enable GDB/LLDB pretty printing",
                        ignoreFailures = false,
                    },
                },
            },
        }

        -- Use same config for C
        dap.configurations.c = dap.configurations.cpp

    end,
}
