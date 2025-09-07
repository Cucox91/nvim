return {
    "nvim-neo-tree/neo-tree.nvim", 
    branch = "v3.x", 
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
      --Adding Keymap for Neo Tree
        --vim.keymap.set('n','<leader>nt',':Neotree filesystem reveal right<CR>', {})
        vim.keymap.set('n','<leader>nt',':Neotree toggle position=right<CR>', {desc = "Toggle Neo-Tree."})
  end
}
