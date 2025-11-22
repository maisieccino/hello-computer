local colors = {
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
  normal = "#24273b",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.black, bg = colors.blue },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.normal },
    b = { fg = colors.white, bg = colors.normal },
    c = { fg = colors.white },
  },
}

local icons = LazyVim.config.icons

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = bubbles_theme,
      component_separators = "",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {},
      lualine_b = { { "branch", separator = { left = "", right = "" }, right_padding = 2, left_padding = 2 } },

      lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
      },

      lualine_y = {
        {
          "location",
          padding = { left = 0, right = 1 },
          separator = {
            left = "",
            right = "",
          },
        },
      },
      lualine_z = {},
    },
  },
}
