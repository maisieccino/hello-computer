return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_b = {},
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {},
    },
  },
}
