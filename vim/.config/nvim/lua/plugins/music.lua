-- A plugin that adds a youtube music player into the editor.
-- Requires: yt-dlp, mpv

---@type LazySpec[]
return {
  {
    "sanjay-np/nvim-yt-player",
    enabled = false,
    config = function()
      require("yt-player").setup({})
    end,
    init = function()
      vim.g.yt_plugin_enabled = true
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      ---@type LazyPlugin?
      if vim.g.yt_plugin_enabled then
        opts.sections.lualine_y[1][1] = "yt-player"
        return opts
      end
    end,
  },
}
