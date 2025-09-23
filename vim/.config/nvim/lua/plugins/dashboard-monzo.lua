local util = require("util")

if not util.is_work() then
  return {}
end

return {
  {
    "snacks.nvim",
    init = function()
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#0188A6" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#48D3B2" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#BBF32E" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#FF4F40" })
    end,
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 2, { icon = " ", key = "p", desc = "Open PR", action = ":Octo pr" })
      opts.dashboard.sections = {
        {
          section = "terminal",
          cmd = "cat ~/.config/nvim/logo",
          height = 7,
          padding = 3,
          align = "center",
        },
        {
          section = "keys",
          gap = 1,
          padding = 1,
        },
        { section = "startup" },
      }
    end,
  },
}
