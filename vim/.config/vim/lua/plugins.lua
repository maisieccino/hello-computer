return {
	{
		'dracula/vim',
		name = 'dracula',
		lazy = true,
		config = function()
			vim.cmd.colorscheme('dracula')
		end,
	},
	{
		{
			import = 'rafi.plugins.telescope',
			opts = {
				defaults = {
					initial_mode = 'normal',
				},
			},
		},
	},
}
