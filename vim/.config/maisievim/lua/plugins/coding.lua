return {
  {
    "echasnovski/mini.surround",
    opts = {
      -- Fix surround keymapping
      mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",
      },
    },
  },
  {
    "outline.nvim",
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
  },
}
