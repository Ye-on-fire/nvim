local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  {
    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        local cmp = require("cmp")

        cmp.setup({
          sources = {
            { name = "nvim_lsp" },
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
          }),
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
        })
      end,
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      cmd = "LspInfo",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
      },
      init = function()
        -- Reserve a space in the gutter
        -- This will avoid an annoying layout shift in the screen
        vim.opt.signcolumn = "yes"
      end,
      config = function()
        local lsp_defaults = require("lspconfig").util.default_config

        -- Add cmp_nvim_lsp capabilities settings to lspconfig
        -- This should be executed before you configure any language server
        lsp_defaults.capabilities =
          vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- LspAttach is where you enable features that only work
        -- if there is a language server active in the file
        vim.api.nvim_create_autocmd("LspAttach", {
          desc = "LSP actions",
          callback = function(event)
            local opts = { buffer = event.buf }

            vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
            vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
            vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
            vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
            vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
            vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
            vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
            vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
            vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
            vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
          end,
        })

        -- These are just examples. Replace them with the language
        -- servers you have installed in your system
        require("lspconfig").basedpyright.setup({
          settings = {
            useLibraryCodeForTypes = false,
            python = {
              pythonPath = vim.fn.exepath("python3"),
            },
          },
        })
        require("lspconfig").lua_ls.setup({})
        require("lspconfig").clangd.setup({})
      end,
    },
  },
})
