vim.pack.add({
	"https://github.com/mikesmithgh/kitty-scrollback.nvim",
})

require("kitty-scrollback").setup({
	{
		restore_options = true,
		status_window = {
			style_simple = true,
		},
	},
})

-- required opts
vim.o.virtualedit = "all" -- all or onemore for correct position
vim.o.termguicolors = true

-- preferred optional opts
vim.opt.shortmess:append("AI") -- no existing swap file or intro message
vim.o.laststatus = 0
vim.o.scrolloff = 0
vim.o.cmdheight = 0
vim.o.ruler = false
-- Set number!
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrollback = 100000
vim.o.list = false
vim.o.showmode = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = false
vim.o.cursorcolumn = false
vim.opt.fillchars = {
	eob = " ",
}
vim.o.lazyredraw = false -- conflicts with noice
vim.o.hidden = true
vim.o.modifiable = true
vim.o.wrap = false
vim.o.report = 999999 -- arbitrary large number to hide yank messages
