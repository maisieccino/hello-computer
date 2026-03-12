---@type LazySpec[]
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "LazyVim" },
        { path = "snacks.nvim" },
        { path = "nvim-treesitter" },
        { path = "lazy.nvim" },
        { path = "noice.nvim" },
        { path = "blink.cmp" },
      },
    },
  },
}
