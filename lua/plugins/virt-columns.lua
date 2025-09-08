return {
  "lukas-reineke/virt-column.nvim",
  lazy = false,  -- so the mapping exists on startup
  config = function()
    local vc = require("virt-column")

    -- 1) Define HLs + an invisible HL (to “hide” cleanly)
    local function set_ruler_hls()
      vim.api.nvim_set_hl(0, "ColorColumn80",  { fg = "#FFA500" }) -- orange
      vim.api.nvim_set_hl(0, "ColorColumn120", { fg = "#FF0000" }) -- red
      vim.api.nvim_set_hl(0, "ColorColumnOFF", { fg = "NONE", bg = "NONE" })
    end
    set_ruler_hls()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_ruler_hls })

    -- 2) Exclusions (optional but helps with UI buffers)
    local EXCLUDE = {
      filetypes = {
        "help","neo-tree","NvimTree","lazy","mason",
        "TelescopePrompt","TelescopeResults",
        "dapui_scopes","dapui_breakpoints","dapui_stacks","dapui_watches",
      },
      buftypes = { "terminal","nofile","prompt" },
    }

    -- 3) Apply state
    local function apply(enabled)
      if enabled then
        vc.setup({
          virtcolumn = "80,120",                       -- must be a STRING
          highlight  = { "ColorColumn80", "ColorColumn120" },
          char       = "│",
          exclude    = EXCLUDE,
        })
      else
        -- hide by removing columns AND making the char/HL invisible
        vc.setup({
          virtcolumn = "",
          highlight  = { "ColorColumnOFF" },
          char       = "",        -- empty char = nothing to draw
          exclude    = EXCLUDE,
        })
      end
      vim.g.__rulers_enabled = enabled and true or false
      vim.cmd("redraw!")         -- force repaint so the change is immediate
    end

    -- start OFF (flip to true if you prefer default ON)
    apply(false)

    -- 4) Re-apply on common “it came back” events
    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TabEnter" }, {
      callback = function() apply(vim.g.__rulers_enabled) end,
    })

    -- 5) Toggle: <leader>cc
    vim.keymap.set("n", "<leader>cc", function()
      apply(not vim.g.__rulers_enabled)
    end, { desc = "Toggle 80/120-col guides (orange/red)" })
  end,
}
