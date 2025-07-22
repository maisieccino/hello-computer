return {
  {
    "folke/snacks.nvim",
    priority = 10000,
    recommended = true,
    lazy = false,
    keys = {
      {
        "<localleader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer (Root dir)",
      },
      {
        "<localleader>a",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Reveal in explorer",
      },
    },
    opts = {
      -- @type snacks.Config
      picker = {
        sources = {
          explorer = {
            layout = {
              hidden = { "input" },
            },
            auto_close = true,
            follow_file = true,
            hidden = true,
          },
        },
      },
      image = {
        enabled = true,
      },
    },
  },
}
