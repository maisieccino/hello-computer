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
    opts = {
      options = {
        mode = "tabs",
        show_close_icon = false,
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        separator_style = "slope",
      },
    },
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
          { ";d", group = "lsp", icon = "" },
          { ";q", group = "query", icon = "" },
          { ";o", group = "obsidian", icon = "󰹕", mode = { "n", "v" } },
        },
      },
    },
  },
}
