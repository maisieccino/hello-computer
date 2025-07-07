vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.cursorline = true
vim.wo.cursorcolumn = true

vim.g.autoformat = true
vim.g.structurestatus = true
vim.filetype.add({ extension = { star = "starlark" } })
vim.opt.wildignore:append({
	"*.firehose.go",
	"*.pb.go",
	"*.proto.desc",
	"*.router.go",
	"*.streams.go",
	"*.typhon.go",
	"*.validator.go",
	"*.rule",
})
if vim.fn.filereadable(vim.fn.expand("$HOME/src/github.com/monzo")) then
	vim.opt.path:append({
		vim.fn.expand("$HOME/src"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/tools"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/libraries"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/catalog/components"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/catalog/owners"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/catalog/systems"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/bin"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/vendor/github.com/monzo"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/vendor/github.com/gocql"),
		vim.fn.expand("$HOME/src/github.com/monzo/wearedev/vendor/github.com/Shopify"),
		vim.fn.expand("$HOME/src/github.com/monzo"),
	})
end

-- Reload waybar on saving config
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*waybar/style.css", "*waybar/config.jsonc" },
	command = "!killall waybar && hyprctl dispatch exec waybar",
})
