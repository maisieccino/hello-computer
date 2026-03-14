---@type LazySpec
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "gotmpl", "gowork" } },
  },
}
