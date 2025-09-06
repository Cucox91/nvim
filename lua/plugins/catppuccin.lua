return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,          -- <— don't lazy-load the theme
    priority = 1000,       -- <— load before everything else
    opts = {
      flavour = "mocha",   -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true },
        telescope = true,
        which_key = true,
        cmp = true,
        gitsigns = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
