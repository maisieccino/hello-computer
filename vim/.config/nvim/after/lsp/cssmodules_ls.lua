---@type vim.lsp.Config
return {
  cmd = { "cssmodules-language-server" },
  filetypes = { "astro", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json" },
}
