return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_y = {
        { "location", padding = { left = 0, right = 1 } },
      },
    },
  },
}
