return {
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdown-toc" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      render_modes = true,
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },
}
