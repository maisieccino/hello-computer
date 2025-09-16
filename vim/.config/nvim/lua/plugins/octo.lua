return {
  { import = "lazyvim.plugins.extras.util.octo" },
  {
    "octo.nvim",
    opts = {
      -- Fixes issues with diffs being wrong(?)
      use_local_fs = true,
      picker = "snacks",
      -- Disable error popups
      suppress_missing_scope = {
        projects_v2 = true,
      },
      users = "mentionable",
    },
  },
}
