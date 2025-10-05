--- @type vim.lsp.Config
return {
  cmd = {
    "protols",
    "--include-paths=" .. vim.env.GOPATH .. "/src," .. vim.env.GOPATH .. "/src/github.com/monzo/wearedev/vendor",
  },
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
  filetypes = { "proto" },
}
