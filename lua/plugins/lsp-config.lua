return {
  -- Mason core (manages LSP binaries)
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      -- keep defaults; make sure Mason's bin is in PATH so exepath() finds it
      PATH = "append",
    },
  },

  -- Mason <-> lspconfig glue
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = function()
      local is_mac = vim.loop.os_uname().sysname == "Darwin"
      local list = {
        "lua_ls",
        -- TypeScript name changed: newer lspconfig uses ts_ls, older uses tsserver.
        -- We ask Mason for both; it will install what it recognizes (harmless to list both).
        "ts_ls",
        "eslint",
      }
      if is_mac then
        table.insert(list, "clangd") -- only try on macOS
      end
      return {
        automatic_installation = true,
        ensure_installed = list,
      }
    end,
  },

  -- Core LSP configs
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- ---------- Diagnostics UI ----------
      vim.diagnostic.config({
        virtual_text = { spacing = 6, prefix = "●" },
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
      local function has_server(name)
        return lspconfig[name] ~= nil
      end

      -- Lua (Neovim config)
      if has_server("lua_ls") then
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
      end

      -- TypeScript / JavaScript — support both names
      local ts_name = has_server("ts_ls") and "ts_ls" or (has_server("tsserver") and "tsserver" or nil)
      if ts_name then
        lspconfig[ts_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- ESLint (guard if plugin/server exists)
      if has_server("eslint") then
        lspconfig.eslint.setup({
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- Optional: only if you have EslintFixAll available
            pcall(function()
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end)
          end,
          capabilities = capabilities,
        })
      end

      -- C / C++ (clangd) — prefer first clangd in PATH (Mason on mac, system on Pi)
      local clangd_bin = vim.fn.exepath("clangd")
      if clangd_bin == "" then clangd_bin = "clangd" end
      if has_server("clangd") then
        lspconfig.clangd.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { clangd_bin, "--background-index", "--clang-tidy" },
          init_options = { compilationDatabasePath = "." },
        })
      end
    end,
  },

  -- (Optional) Quick diagnostics list
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    },
  },
}
