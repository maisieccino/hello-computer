return {
  {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
      "jmbuhr/otter.nvim",
    },
    opts = {
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    keys = function()
      return {
        {
          "<localleader>qr",
          function()
            require("quarto.runner").run_cell()
          end,
          desc = "Run cell",
          silent = true,
        },
        {
          "<localleader>qa",
          function()
            require("quarto.runner").run_above()
          end,
          desc = "Run cell and above",
          silent = true,
        },
        {
          "<localleader>qA",
          function()
            require("quarto.runner").run_above()
          end,
          desc = "Run all",
          silent = true,
        },
        {
          "<localleader>ql",
          function()
            require("quarto.runner").run_line()
          end,
          desc = "Run line",
          silent = true,
        },
        {
          "<localleader>qp",
          "<cmd>QuartoPreview<CR>",
          desc = "Show preview",
          silent = true,
        },
      }
    end,
  },
  {
    "3rd/image.nvim",
    ft = { "quarto" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = { enabled = false },
      },
    },
  },
  {
    "benlubas/molten-nvim",
    ft = { "quarto", "jupyter" },
    dependencies = { "3rd/image.nvim" },
    config = function()
      vim.g.molten_image_provider = "image.nvim"
    end,
    keys = {
      { "<localleader>qo", ":noautocmd MoltenEnterOutput<CR>", desc = "Open output window" },
    },
  },
  {
    "nvim-lspconfig",
    ft = "quarto",
    opts = {
      servers = {
        r_language_server = {
          enabled = true,
          mason = false,
        },
      },
    },
  },
}
