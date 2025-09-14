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
    "nvimtools/none-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          -- null_ls.builtins.diagnostics.alex,
        },
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      render_modes = true,
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      checkbox = {
        enabled = true,
      },
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    keys = {
      { "<localleader>n", "<cmd>NoNeckPain<CR>", desc = "Toggle no neck pain" },
    },
    opts = {
      bufferOptionsWo = {
        wrap = true,
      },
    },
  },
}
