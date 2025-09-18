vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.g.elite_mode = true

-- Format on save
vim.g.autoformat = true

local opt = vim.opt

opt.autowrite = false
opt.expandtab = true
opt.number = true
opt.relativenumber = true

opt.textwidth = 80
opt.mouse = "nv"
opt.spelloptions:append("camel")
opt.shortmess:append({
  c = true,
  I = true,
  W = true,
})

opt.timeoutlen = 500 -- Faster timeout on mapped sequence to complete.
opt.ttimeoutlen = 10 -- Faster timeout on key code sequence to complete.

opt.tabclose:append({ "uselast" })

opt.sessionoptions:remove({ "blank", "buffers", "terminal" })
opt.sessionoptions:append({ "globals", "skiprtp" })

opt.formatoptions = opt.formatoptions
  - "a" -- auto formatting paragraphs
  - "t" -- auto wrap textwidth
  + "c" -- auto wrap comments
  + "q" -- allow formatting comments w/ gq
  + "o" -- continue comments on o/O. remove with ctrl+u
  + "r" -- continue comment when <enter> in insert
  + "n" -- indent lists nicely
  + "j" -- tidy up comments
  - "2" -- don't indent first line of para

opt.fillchars = {
  foldopen = "", -- 󰅀 
  foldclose = "", -- 󰅂 
  fold = " ", -- ⸱
  foldsep = " ",
  diff = "╱",
  eob = " ",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
opt.showbreak = "⤷  " -- ↪	⤷
opt.listchars = {
  tab = "  ",
  extends = "⟫",
  precedes = "⟪",
  conceal = "",
  nbsp = "␣",
  trail = "·",
}

opt.breakindent = true
opt.showcmd = false
opt.numberwidth = 2
opt.cmdheight = 0
opt.colorcolumn = "+0" -- column at textwidth
opt.showtabline = 2
opt.helpheight = 0
opt.winwidth = 30
opt.winheight = 1
opt.winminheight = 1

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
})

-- vim.g.loaded_python3_provider = 0
vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/shims/python3")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.markdown_recommended_style = 0
vim.g.yaml_indent_multiline_scalar = 1

vim.g.no_gitrebase_maps = 1
vim.g.no_map_maps = 1

vim.filetype.add({
  filename = {
    Brewfile = "ruby",
    justfile = "just",
    Justfile = "just",
    [".buckconfig"] = "toml",
    [".flowconfig"] = "ini",
    [".jsbeautifyrc"] = "json",
    [".jscsrc"] = "json",
    [".watchmanconfig"] = "json",
    ["helmfile.yaml"] = "yaml",
    ["todo.txt"] = "todotxt",
    ["yarn.lock"] = "yaml",
  },
  extension = {
    ["ipynb"] = "markdown",
  },
  pattern = {
    ["%.config/git/users/.*"] = "gitconfig",
    ["%.kube/config"] = "yaml",
    [".*%.js%.map"] = "json",
    [".*%.postman_collection"] = "json",
    ["Jenkinsfile.*"] = "groovy",
    ["alerts/.*/.*yaml"] = "promql",
  },
})
