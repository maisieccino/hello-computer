---@type LazySpec[]
return {
  {
    "pwntester/octo.nvim",
    -- dependencies = {
    --   "nvim-telescope/telescope.nvim",
    -- },
    opts = {
      -- Fixes issues with diffs being wrong(?)
      use_local_fs = true,
      -- temporarily until https://github.com/pwntester/octo.nvim/issues/1027
      picker = "snacks",
      -- picker = "telescope",
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
    },
  },
}
