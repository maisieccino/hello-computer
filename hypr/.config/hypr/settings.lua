local M = {
	programs = {
		picker = "~/bin/fzfmenu.zsh",
		launcher = "hyprlauncher",
		terminal = "kitty --session none",
		file_manager = "thunar",
		menu = "wofi --show drun",
	},
	colors = {
		yellow = "rgba(ffc700ee)",
		pink = "rgba(fd98ceee)",
		blue = "rgba(8eeaeaee)",
		grey = "rgba(595959aa)",
		shadow = "rgba(1a1a1aee)",
	},
	keys = {
		modifier = "L_ALT",
	},
}

-- Config for hypr tools
return M
