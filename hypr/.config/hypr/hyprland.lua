local settings = require("settings")

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

--TODO: Reserved virtual monitor for VNC
-- hl.monitor({
--   output = "",
--   mode = "addreserved",
--   position
-- })

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
end)

local env_vars = {
	["XCURSOR_SIZE"] = "24",
	["HYPRCURSOR_SIZE"] = "24",
}
for k, v in pairs(env_vars) do
	hl.env(k, v)
end

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = { 5, 10, 20, 10 },
		border_size = 5,
		col = {
			active_border = {
				colors = { settings.colors.yellow, settings.colors.pink, settings.colors.blue },
				angle = 45,
			},
			inactive_border = settings.colors.grey,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = settings.colors.shadow,
		},

		blur = {
			enabled = true,
			size = 10,
			passes = 3,
			vibrancy = 0.1696,
		},
	},
})

-- Animation
hl.config({ animations = { enabled = true } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "overshoot" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "overshoot", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "overshoot", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.8, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.2, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	master = {
		new_status = "master",
		orientation = "right",
	},
})

hl.config({
	misc = {
		force_default_wallpaper = false,
		disable_hyprland_logo = true,
	},
})

-- Input
hl.config({
	input = {
		kb_layout = "gb",
		kl_variant = "mac",
		follow_mouse = true,

		natural_scroll = true,
		touchpad = {
			natural_scroll = true,
		},
	},
})

-- Keys
local main_mod = settings.keys.modifier

---@alias dispatcher HL.Dispatcher|function
---@param keys string
---@param dispatcher dispatcher
---@param opts HL.BindOptions|nil
local bind_mod = function(keys, dispatcher, opts)
	hl.bind(main_mod .. " + " .. keys, dispatcher, opts)
end

---@alias bind dispatcher|[dispatcher,HL.BindOptions]
---@type table<string,bind>
local binds = {
	["Space"] = hl.dsp.exec_cmd(settings.programs.launcher),
	["return"] = hl.dsp.exec_cmd(settings.programs.terminal),
	["Q"] = hl.dsp.window.close(),
	["E"] = hl.dsp.exec_cmd(settings.programs.file_manager),
	["V"] = hl.dsp.window.float({ action = "toggle" }),
	["P"] = hl.dsp.window.pseudo({ action = "toggle" }),
	["H"] = hl.dsp.layout("togglesplit"),
	["T"] = hl.dsp.group.toggle(),
	["tab"] = hl.dsp.group.next(),
	["SHIFT + tab"] = hl.dsp.group.prev(),
	["CONTROL + Q"] = hl.dsp.exec_cmd("hyprlock"),
	["SHIFT + M"] = hl.dsp.exec_cmd("~/bin/powermenu.sh"),
	["SHIFT + F"] = hl.dsp.window.fullscreen({ action = "toggle" }),
	-- Movement
	["J"] = hl.dsp.focus({ direction = "left" }),
	["K"] = hl.dsp.focus({ direction = "down" }),
	["L"] = hl.dsp.focus({ direction = "up" }),
	["semicolon"] = hl.dsp.focus({ direction = "right" }),
	["SHIFT + J"] = hl.dsp.window.move({ direction = "left" }),
	["SHIFT + K"] = hl.dsp.window.move({ direction = "down" }),
	["SHIFT + L"] = hl.dsp.window.move({ direction = "up" }),
	["SHIFT + semicolon"] = hl.dsp.window.move({ direction = "right" }),
	-- Float + pin window (e.g. picture-in-picture)
	["SHIFT + P"] = function()
		hl.dsp.window.float({ action = "toggle" })
		hl.dsp.window.pin({ action = "toggle" })
	end,
	-- Scratchpad
	["S"] = hl.dsp.workspace.toggle_special("scratch"),
	["SHIFT + S"] = function()
		hl.dsp.window.float()
		hl.dsp.window.move({ workspace = "special:scratch" })
	end,
	-- Mouse actions
	["mouse_down"] = hl.dsp.focus({ workspace = "e+1" }),
	["mouse_up"] = hl.dsp.focus({ workspace = "e-1" }),
	["mouse:272"] = {
		hl.dsp.window.drag(),
		{ mouse = true },
	},
	["mouse:273"] = {
		hl.dsp.window.resize(),
		{ mouse = true },
	},
	-- Multimedia keys
	["XF86AudioRaiseVolume"] = {
		hl.dsp.exec_cmd("pamixer -i 5"),
		{ locked = true, repeating = true },
	},
	["XF86AudioLowerVolume"] = {
		hl.dsp.exec_cmd("pamixer -d 5"),
		{ locked = true, repeating = true },
	},
	["XF86AudioMute"] = hl.dsp.exec_cmd("pamixer -t"),
	["XF86AudioMicMute"] = hl.dsp.exec_cmd("pamixer --default-source -m"),
	["XF86MonBrightnessUp"] = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
	["XF86MonBrightnessDown"] = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
	["XF86AudioPause"] = hl.dsp.exec_cmd("playerctl play-pause"),
	["XF86AudioPlay"] = hl.dsp.exec_cmd("playerctl play-pause"),
	["XF86AudioPrev"] = hl.dsp.exec_cmd("playerctl previous"),
	["XF86AudioNext"] = hl.dsp.exec_cmd("playerctl next"),
	["SUPER + 3"] = hl.dsp.exec_cmd("wtype ##"),
	["SHIFT + T"] = hl.dsp.exec_cmd("swaync-client -t"),
	["SHIFT + Print"] = hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'),
	["Print"] = hl.dsp.exec_cmd("grim - | swappy -f -"),
	["code:51"] = hl.dsp.exec_cmd("proton-pass"),
}

-- Workspace binds
for i = 1, 10 do
	local key = i % 10
	binds[key] = hl.dsp.focus({ workspace = i })
	binds["SHIFT +" .. key] = hl.dsp.window.move({ workspace = i })
end

for keys, bind in pairs(binds) do
	if type(bind) == "table" then
		bind_mod(keys, bind[1], bind[2])
	end
	bind_mod(keys, bind)
end

-- Window rules
hl.window_rule({
	name = "suppress maximise events",
	match = { class = ".*" },
	suppress_event = "maximize",
})
hl.window_rule({
	name = "fix xywayland dragging issues",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
hl.window_rule({
	name = "Proton pass",
	match = {
		class = "Proton Pass",
	},
	float = true,
	center = true,
	size = { 1000, 600 },
})
hl.window_rule({
	name = "fzf-menu",
	match = {
		class = "fzf-menu",
	},
	float = true,
	center = true,
	size = { 1000, 600 },
	stay_focused = true,
	dim_around = true,
})
hl.window_rule({
	name = "pavucontrol",
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	float = true,
	center = true,
})

-- Layer rules
hl.layer_rule({
	name = "notifications + wofi",
	match = { namespace = "(notifications|wofi)" },
	blur = true,
	ignore_alpha = false,
})
hl.layer_rule({
	name = "sway notification center",
	match = { namespace = "swaync-(control-center|notification-window)" },
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.1,
})
