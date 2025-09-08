vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- For Absolute line numbers
vim.opt.number = true

--For Relative line numbers
--vim.opt.relativenumber = true

--When keeping bothlines it will display current line plus difference.

--Here we will add a vertical line to keep the code to 80 to 120 Lines.
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "orange" }) -- orange

vim.keymap.set("n", "<leader>cc", function()
  if #vim.opt.colorcolumn:get() == 0 then
    vim.opt.colorcolumn = "80"
  else
    vim.opt.colorcolumn = ""
  end
end, { desc = "Toggle 80-col guide" })
