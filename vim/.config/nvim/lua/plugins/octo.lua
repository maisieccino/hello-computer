return {
  { import = "lazyvim.plugins.extras.util.octo" },
  {
    "octo.nvim",
    -- Disable error popups
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
    },
  },
}
