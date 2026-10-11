---@type LazySpec[]
return {
  {
    "nvim-mini/mini.hipatterns",
    opts = function(_, opts)
      local hi = require("mini.hipatterns")
      ---Highlighter for rgba()
      ---@param match string
      ---@return string|nil
      local rgba_color = function(_, match)
        local hex = match:match("rgba%(#?(%x%x%x%x%x%x)%x%x%)")
        return hi.compute_hex_color_group("#" .. hex, "bg")
      end
      opts.highlighters.rgba_hex_color = {
        pattern = "rgba%(#?%x%x%x%x%x%x%x%x%)",
        group = rgba_color,
        extmark_opts = { priority = 200 },
      }
      return opts
    end,
  },
}
