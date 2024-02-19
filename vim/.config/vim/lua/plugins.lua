return {
	{
		'dracula/vim',
		name = "dracula",
		lazy = true,
		config = function()
			vim.cmd.colorscheme("dracula")
		end
	},
	{
		'rafi.plugins.extras.coding.copilot',
		enabled = false,
	},
	{
		dir = "~/src/github.com/monzo/wearedev/tools/editors/nvim/nvim-monzo",
		name = "monzo",
	}
}
