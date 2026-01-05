-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Helper functions
local map = vim.keymap.set
local unmap = function(modes, lhs)
  modes = type(modes) == "string" and { modes } or modes
  lhs = type(lhs) == "string" and { lhs } or lhs
  for _, mode in pairs(modes) do
    for _, l in pairs(lhs) do
      pcall(vim.keymap.del, mode, l)
    end
  end
end

map("n", "<localleader>f", "<leader>ff", { remap = true, desc = "Find files (Root Dir)" })
map("n", "<localleader>F", "<leader>fF", { remap = true, desc = "Find files (cwd)" })
map("n", "<localleader>g", "<leader>sg", { remap = true, desc = "Grep (Root dir)" })
map("n", "<localleader>G", "<leader>sG", { remap = true, desc = "Grep (cwd)" })
map("n", "<localleader>t", "<leader>ss", { remap = true, desc = "Goto Symbol" })
map("n", "<localleader>T", "<leader>sS", { remap = true, desc = "Goto Symbol (Workspace)" })
map("n", "<localleader>x", "<leader>fr", { remap = true, desc = "Recent" })
map("n", "<localleader>X", "<leader>fR", { remap = true, desc = "Recent (cwd)" })

if vim.F.if_nil(vim.g.elite_mode, false) then
  -- Elite-mode: Arrow-keys resize window
  map("n", "<Up>", "<cmd>resize +1<cr>", { desc = "Increase Window Height" })
  map("n", "<Down>", "<cmd>resize -1<cr>", { desc = "Decrease Window Height" })
  map("n", "<Left>", "<cmd>vertical resize +1<cr>", { desc = "Increase Window Width" })
  map("n", "<Right>", "<cmd>vertical resize -1<cr>", { desc = "Decrease Window Width" })
  unmap("n", { "<C-Up>", "<C-Down>", "<C-Left>", "<C-Right>" })
else
  -- Moves through display-lines, unless count is provided
  map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
  map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
end

-- Comment out code
unmap("n", { "gra", "gri", "grr", "grn" })
map("n", "<Leader>v", "gcc", { remap = true, desc = "Comment Line" })
map("x", "<Leader>v", "gc", { remap = true, desc = "Comment Selection" })

map("n", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<CR>" or "za"
end, { expr = true, desc = "Toggle Fold" })
