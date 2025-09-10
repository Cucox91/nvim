return {
  -- Mason core (manages LSP binaries)
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true, -- same as: function() require("mason").setup() end
  },

  -- Mason <-> lspconfig glue
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "ts_ls",    -- TypeScript/JavaScript
        "eslint",   -- ESLint LSP (for JS/TS diagnostics)
        "clangd",   -- C Compiler added by me.
        -- add more here as needed: "pyright", "omnisharp", etc.
      },
    },
  },

  -- Core LSP configs
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- ---------- Diagnostics UI ----------
      vim.diagnostic.config({
        virtual_text = { spacing = 6, prefix = "●" }, -- inline text
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- ---------- Capabilities ----------
      local ok_cmp, cmp_caps = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if ok_cmp then
        capabilities = cmp_caps.default_capabilities(capabilities)
      end

      -- ---------- on_attach with buffer-local maps ----------
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "gi", vim.lsp.buf.implementation)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "<leader>ca", vim.lsp.buf.code_action)
        map("n", "[d", vim.diagnostic.goto_prev)
        map("n", "]d", vim.diagnostic.goto_next)
        map("n", "<leader>e", vim.diagnostic.open_float)
        map("n", "<leader>q", vim.diagnostic.setloclist)
      end

      local lspconfig = require("lspconfig")

      -- Lua (Neovim config)
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- TypeScript / JavaScript
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- ESLint (surfaces lint warnings/errors for JS/TS)
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Optional: auto-fix on save if your project wants it
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        capabilities = capabilities,
      })

      -- C configurations
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })

    end,
  },

  -- (Optional but recommended) Quick diagnostics list
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    },
  },
}
