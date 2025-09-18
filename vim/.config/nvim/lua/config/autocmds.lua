-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_del_augroup_by_name("lazyvim_last_loc")
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("maisieccino." .. name, { clear = true })
end

-- Spell checking in text file types
-- Enable soft wrapping too.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell"),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.o.textwidth = 0
    vim.o.wrap = true
  end,
})
--
-- Go to last loc when opening a buffer, see ':h last-position-jump'
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit", "commit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("undo_disable"),
  pattern = { "/tmp/*", "*.tmp", "*.bak", "COMMIT_EDITMSG", "MERGE_MSG" },
  callback = function(event)
    vim.opt_local.undofile = false
    if event.file == "COMMIT_EDITMSG" or event.file == "MERGE_MSG" then
      vim.opt_local.swapfile = false
    end
  end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre" }, {
  group = augroup("secure"),
  pattern = {
    "/tmp/*",
    "$TMPDIR/*",
    "$TMP/*",
    "$TEMP/*",
    "*/shm/*",
    "/private/var/*",
  },
  callback = function()
    vim.opt_local.undofile = false
    vim.opt_local.swapfile = false
    vim.opt_global.backup = false
    vim.opt_global.writebackup = false
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "blame",
    "fugitive",
    "fugitiveblame",
    "httpResult",
    "lspinfo",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("proto_ls"),
--   pattern = {
--     "proto",
--   },
--   callback = function(event)
--     local pipe = vim.uv.new_pipe()
--     local sockname = os.tmpname()
--     if vim.uv.os_uname().sysname == "Darwin" and sockname:match("^/tmp") then
--       -- In OS X /tmp links to /private/tmp
--       sockname = "/private" .. sockname
--     end
--     assert(pipe:bind(sockname))
--
--     local stdout = vim.uv.new_pipe()
--     local stderr = vim.uv.new_pipe()
--     local function on_read(_, data)
--       if data then
--         print(data)
--       end
--     end
--
--     local function on_error(_, data)
--       if data then
--         print(data)
--       end
--     end
--
--     local proc = vim.uv.spawn("/Users/maisiebell/bin/protols", {
--       cwd = vim.fn.getcwd(),
--       args = {
--         "serve",
--         "--pipe",
--         sockname,
--       },
--       stdio = { nil, stdout, stderr },
--     }, function(code, signal)
--       print("Exited with code " .. code)
--     end)
--     vim.uv.read_start(stdout, on_read)
--     vim.uv.read_start(stderr, on_error)
--
--     vim.wait(1000, function() end)
--
--     local client = vim.lsp.rpc.connect(sockname)
--     vim.lsp.start({
--       name = "protols",
--       cmd = client,
--     })
--   end,
-- })

-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print("Error: Could not open new notebook file for writing.")
  end
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
