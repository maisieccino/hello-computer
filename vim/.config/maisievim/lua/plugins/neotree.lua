return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<localleader>e", "<leader>fe", desc = "Explorer Tree (Root dir)", remap = true },
      { "<localleader>E", "<leader>fE", desc = "Explorer Tree (cwd)", remap = true },
		{
			'<localleader>a',
			function()
				require('neo-tree.command').execute({ reveal = true, dir = LazyVim.root() })
			end,
			desc = 'Reveal in Explorer',
		},
		{
			'<localleader>A',
			function()
				require('neo-tree.command').execute({ reveal = true, dir = vim.uv.cwd() })
			end,
			desc = 'Reveal in Explorer (cwd)',
		},
    },
  },
}
