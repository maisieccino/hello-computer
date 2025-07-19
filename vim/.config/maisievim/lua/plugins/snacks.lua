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
    -- @type snacks.Config
    opts = {
      explorer = {
        auto_hide = { "input" },
      },
      picker = {
        explorer = {
          layout = {
            hidden = { "input" },
          },
          follow_file = true,
          show_hidden = true,
        },
      },
      image = {
        enabled = true,
      },
    },
  },
}
