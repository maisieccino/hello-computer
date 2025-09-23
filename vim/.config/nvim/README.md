# Maisievim

My own config used to set up neovim with [LazyVim](https://www.lazyvim.org/)

## Installation

You can install this alongside your current neovim config:

* Copy this directory to `~/.config/maisievim`
* `NVIM_APPNAME=maisievim nvim`
* Open `nvim` and let Lazy install.
* ???
* Profit

## Keybinds

`which-key.nvim` should help with finding most of these. `;`, `<space>` will trigger the popup, or `:WhichKey`

`;qd` in an SQL file will send your query to BigQuery and return an estimate of how much data will be used.

`;q` also has some useful commands for running Jupyter notebooks, via `jupytext` and `molten`. Notebooks will take the form of a markdown file automatically.
