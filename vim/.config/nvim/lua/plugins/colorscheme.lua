local util = require("util")
---@type LazySpec
return {
  {
    "LazyVim/LazyVim",
    opts = function(opts)
      return vim.tbl_deep_extend("force", {
        colorscheme = util.is_work() and "catppuccin-macchiato" or "kanagawa-dragon",
      }, opts)
    end,
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
