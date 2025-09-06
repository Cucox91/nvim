return  { 
  "nvim-treesitter/nvim-treesitter",
  branch = 'master', 
  lazy = false, 
  build = ":TSUpdate",
  config = function()
    --Setup TreeSitter
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "c", "typescript"},
      highlight = {enable = true},
      indent = {enable = true},
    }) 
  end
}
  
