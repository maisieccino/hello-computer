local util = require("util")

if util.is_work() then
  return {}
end

return {
  "snacks.nvim",
  ---@param opts snacks.Config
  opts = function(_, opts)
    table.insert(
      opts.dashboard.preset.keys,
      2,
      { icon = "󰹕 ", key = "o", desc = "Open Notes", action = ":e ~/github.com/maisieccino/notes/Home.md" }
    )
    opts.dashboard.sections = {
      {
        section = "terminal",
        cmd = "chafa ~/.config/nvim/wallpaper.jpg --probe off --format symbols --size 30x17 --align vcenter,right; sleep .1",
        height = 30,
        align = "right",
        width = 60,
        padding = 1,
      },
      { pane = 2, section = "keys", padding = 1 },
      {
        pane = 2,
        section = "terminal",
        width = 60,
        height = 11,
        ttl = 5,
        title = "Water consumption",
        cmd = "cd ~/github.com/maisieccino/notes && type chart &>/dev/null && chart",
        padding = 1,
      },
      {
        pane = 2,
        section = "terminal",
        ttl = 5 * 60,
        title = "GitHub Notifications",
        cmd = "gh notify -s -n6",
        width = 80,
      },
    }
  end,
}
