---@type LazySpec
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
      colorscheme = "oxocarbon",
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
  {
    "akinsho/bufferline.nvim",
    init = function()
      local bufline = require("catppuccin.special.bufferline")
      function bufline.get()
        return bufline.get_theme()
      end
    end,
  },
}
