return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- 1) UI
    dapui.setup()

    -- 2) Install & auto-configure debug adapters (including codelldb)
    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb" }, -- <- this installs the adapter via Mason
      automatic_installation = true,
      handlers = {
        -- Default handler sets up all adapters Mason knows about
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    })

    -- 3) Explicit codelldb adapter path (works cross-platform with Mason)
    --    (mason-nvim-dap usually wires this up for you, but we set it for clarity)
    local codelldb_path = vim.fn.stdpath("data")
        .. "/mason/packages/codelldb/extension/adapter/codelldb"

    dap.adapters.codelldb = dap.adapters.codelldb or {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
      },
    }

    -- 4) Launch configs for C / C++
    --    You can change 'program' to a fixed path if you prefer.
    local c_launch = {
      name = "Launch (codelldb)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          vim.fn.getcwd() .. "/",
          "file"
        )
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      -- env = { "FOO=bar" },
      -- args = { "--flag" },
    }

    dap.configurations.c = { c_launch }
    dap.configurations.cpp = { c_launch }

    -- 5) Auto-open/close DAP UI like you had
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- 6) Keymaps (keep yours, add a couple useful ones)
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
    vim.keymap.set("n", "<F10>", dap.step_over, {})
    vim.keymap.set("n", "<F11>", dap.step_into, {})
    vim.keymap.set("n", "<F12>", dap.step_out, {})
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
    vim.keymap.set("n", "<Leader>dl", dap.run_last, {})
    vim.keymap.set("n", "<Leader>du", dapui.toggle, {})
  end,
}
