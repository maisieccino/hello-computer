---@type LazySpec
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
      -- colorscheme = "oxocarbon",
      colorscheme = "kanagawa-dragon",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
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
