return {
  {
    "tpope/vim-fugitive",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      vim.keymap.set("n", "<Leader>tb", dap.toggle_breakpoint, {})
      vim.keymap.set("n", "<Leader>tc", function()
        require("dap").continue()
      end)
      vim.keymap.set("n", "<Leader>sv", function()
        require("dap").step_over()
      end)
      vim.keymap.set("n", "<Leader>si", function()
        require("dap").step_into()
      end)
      vim.keymap.set("n", "<Leader>so", function()
        require("dap").step_out()
      end)
    end,
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "C:\\Users\\y3206\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\pythonw.exe"
      require("dap-python").setup(path)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        -- "pyright",
        "debugpy",
        "ruff",
        "clangd",
      },
    },
  },
}
