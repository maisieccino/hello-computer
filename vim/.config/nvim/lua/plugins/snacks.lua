return {
  {
    "folke/snacks.nvim",
    priority = 10000,
    recommended = true,
    lazy = false,
    ---@type LazyKeysSpec[]
    keys = {
      {
        "<localleader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer (Root dir)",
      },
      { "<leader>gi", false },
      { "<leader>gI", false },
      { "<leader>gp", false },
      { "<leader>gP", false },
      {
        "<localleader>a",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Reveal in explorer",
      },
    },
    ---@type snacks.Config
    opts = {
      gh = {},
      picker = {
        win = {
          input = {
            keys = {
              ["<c-t>"] = { "tab", mode = { "n", "i" } },
            },
          },
        },
        sources = {
          explorer = {
            win = {
              input = {
                keys = {
                  ["<C-t>"] = { "tab", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<C-t>"] = "tab",
                },
              },
            },
            layout = {
              hidden = { "input" },
            },
            auto_close = true,
            follow_file = true,
            hidden = true,
          },
          gh_pr = {},
          -- https://github.com/folke/snacks.nvim/issues/2446#issuecomment-3498850414
          gh_diff = {
            auto_close = false,
            layout = {
              preset = "right",
              hidden = { "preview" },
            },
          },
        },
      },
      image = {
        enabled = true,
        img_dirs = { "img", "images", "assets", "Assets", "static", "public", "media", "attachments", "assets/images" },
        math = {
          latex = {
            packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools", "pgfplots" },
          },
        },
      },
    },
  },
}
