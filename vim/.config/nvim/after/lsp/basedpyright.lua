-- @type vim.lsp.Config
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
    analysis = {
      autoImportCompletions = true,
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      typeCheckingMode = "off",
    },
  },
}
