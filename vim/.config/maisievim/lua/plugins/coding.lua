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
  {
    "blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "<leader>V", "<Plug>(comment_toggle_blockwise_current)", mode = "n", desc = "Comment" },
      { "<leader>V", "<Plug>(comment_toggle_blockwise_visual)", mode = "x", desc = "Comment" },
    },
    opts = function(_, opts)
      local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        opts.pre_hook = tcc.create_pre_hook()
      end
    end,
  },

  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
		-- stylua: ignore
		keys = {
			{ '<leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'Erase Whitespace' },
		},
    opts = {},
  },
}
