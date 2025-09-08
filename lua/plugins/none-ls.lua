return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    local has_eslint_config = function(utils)
      return utils.root_has_file({
        ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json",
        ".eslintrc.yaml", ".eslintrc.yml",
        "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts",
      })
    end

    null_ls.setup({
      sources = {
        -- use extras modules for eslint_d
        require("none-ls.diagnostics.eslint_d").with({ condition = has_eslint_config }),
        require("none-ls.code_actions.eslint_d").with({ condition = has_eslint_config }),
        -- prettierd is still in core builtins
        null_ls.builtins.formatting.prettierd,
      },
    })

    local ok_mnls, mason_null_ls = pcall(require, "mason-null-ls")
    if ok_mnls then
      mason_null_ls.setup({
        --ensure_installed = { "eslint_d", "prettierd" },
        automatic_installation = true,
      })
    end

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Code Formatter" })
  end,
}
