require("snacks")
return {
  {
    "lualine.nvim",
    opts = {
      sections = {
        lualine_a = {},
      },
    },
  },
  {
    "bufferline.nvim",
    opts = function()
      local bufferline = require("bufferline")
      return {
        options = {
          style_preset = bufferline.style_preset.no_italic,
          mode = "tabs",
          show_close_icon = false,
          show_buffer_close_icons = false,
          always_show_bufferline = true,
          indicator = {
            style = "icon",
          },
          separator_style = "thick",
          color_icons = true,
        },
      }
    end,
  },
  {
    "snacks.nvim",
    keys = {
      { "<localleader>dd", Snacks.picker.lsp_definitions, desc = "Definitions" },
      { "<localleader>di", Snacks.picker.lsp_implementations, desc = "Implementations" },
      { "<localleader>dr", Snacks.picker.lsp_references, desc = "References" },
      { "<localleader>da", vim.lsp.buf.code_action(), desc = "Code Actions" },
      { "<localleader>da", vim.lsp.buf.code_action(), mode = "x", desc = "Code Actions" },
    },
  },
  {
    "which-key.nvim",
    opts = {
      icons = {
        group = " ",
      },
      spec = {
        {
          { ";", group = "picker" },
          { ";c", group = "code", icon = "" },
          { ";d", group = "lsp", icon = "" },
          { ";q", group = "query", icon = "" },
          { ";o", group = "obsidian", icon = "󰹕", mode = { "n", "v" } },
        },
      },
    },
  },
}
