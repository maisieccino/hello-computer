-- Problem running? Make sure that typescript is added as a dev dependency to
-- your Yarn project.
---@type vim.lsp.Config
return {
  root_markers = {
    "package.json",
    ".git",
  },
  filetypes = { "astro" },
}
