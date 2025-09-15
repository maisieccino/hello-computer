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

-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
  vim.schedule(function()
    local kernels = vim.fn.MoltenAvailableKernels()
    local try_kernel_name = function()
      local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
      return metadata.kernelspec.name
    end
    local ok, kernel_name = pcall(try_kernel_name)
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      if venv ~= nil then
        kernel_name = string.match(venv, "/.+/(.+)")
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(("MoltenInit %s"):format(kernel_name))
    end
    vim.cmd("MoltenImportOutput")
    vim.cmd("QuartoActivate")
  end)
end
vim.api.nvim_create_autocmd("BufAdd", {
  pattern = { "*.ipynb" },
  callback = imb,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ipynb" },
  callback = function(e)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
      imb(e)
    end
  end,
})
-- automatically export output chunks to a jupyter notebook on write
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ipynb" },
  callback = function()
    if require("molten.status").initialized() == "Molten" then
      vim.cmd("MoltenExportOutput!")
    end
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
