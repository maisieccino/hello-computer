return {
	{
		'dracula/vim',
		name = "dracula",
		lazy = true,
		config = function()
			vim.cmd.colorscheme("dracula")
		end
	}
}
