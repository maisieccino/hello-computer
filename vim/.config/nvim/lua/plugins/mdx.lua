return {
  {
    -- Register MDX as a markdown file
    "nvim-treesitter",
    init = function()
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
