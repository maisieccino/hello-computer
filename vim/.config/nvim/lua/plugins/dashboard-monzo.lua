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
      table.insert(opts.dashboard.preset.keys, 2, { icon = " ", key = "P", desc = "Open PR", action = ":Octo pr" })
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
          gap = 0,
          padding = 1,
        },
        {
          pane = 2,
          section = "terminal",
          ttl = 5 * 60,
          title = "PRs to review (R to show)",
          cmd = {
            "bash",
            "-c",
            "PAGER=cat gh search prs user-review-requested:@me is:open",
          },
          action = ":Octo search is:pr user-review-requested:@me is:open",
          key = "R",
          width = 100,
        },
        {
          pane = 2,
          section = "terminal",
          ttl = 5 * 60,
          title = "My open PRs (m to show)",
          cmd = {
            "bash",
            "-c",
            'PAGER=cat gh search prs author:@me is:open org:monzo --json repository,number,title --template \'{{range .}}{{tablerow .repository.name (printf "#%v" .number | autocolor "green") .title }}{{end}}\'',
          },
          action = ":Octo search is:pr author:@me is:open org:monzo",
          key = "m",
          width = 100,
        },
        {
          pane = 2,
          section = "terminal",
          ttl = 5 * 60,
          title = "Tenancy status",
          cmd = "tenancy status",
          width = 100,
        },
      }
    end,
  },
}
