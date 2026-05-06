local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    client:notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

local function check_poetry()
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    if client.settings and client.settings.python then
      if client.settings.python.pythonPath and client.settings.python.pythonPath:match("pypoetry") then
        vim.notify("nothing to do", "debug")
        return
      end
    end
  end

  local which_python = vim
    .system({
      "which",
      "python",
    })
    :wait(1000)
  if which_python.code ~= 0 then
    return
  end
  local path = which_python.stdout
  if path == nil then
    return
  end
  if path:match("pypoetry") then
    vim.notify("Updating python path to" .. path, "debug")
    set_python_path(path)
  end
end

---@type vim.lsp.Config
return {
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
      },
    },
    python = {
      venvPath = "/Users/maisiebell/Library/Caches/pypoetry/virtualenvs/",
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure basedpyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
    vim.schedule(check_poetry)
  end,
}
