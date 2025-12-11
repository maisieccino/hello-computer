---@type LazySpec[]
return {
  {
    "pwntester/octo.nvim",
    opts = {
      -- Fixes issues with diffs being wrong(?)
      use_local_fs = true,
      picker = "snacks",
      -- Disable error popups
      suppress_missing_scope = {
        projects_v2 = true,
      },
      -- High timeout needed for loading reviewers list.
      -- TODO: Possible to optimise this?
      timeout = 20000,
      users = "search",
    },
    keys = {
      { "<leader>gp", "<cmd>Octo pr<CR>", desc = "Open PR (octo)" },
      { "@", mode = "i", ft = "octo", false },
      { "#", mode = "i", ft = "octo", false },
      { ":", mode = "i", ft = "octo", false },
    },
  },
}
