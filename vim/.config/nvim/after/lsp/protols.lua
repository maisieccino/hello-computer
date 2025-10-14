local util = require("util")

--- @type vim.lsp.Config
local config = {
  cmd = {
    "protols",
  },
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
  filetypes = { "proto" },
}

if util.is_work() then
  config.cmd[#config.cmd + 1] = "--include-paths="
    .. vim.env.GOPATH
    .. "/src,"
    .. vim.env.GOPATH
    .. "/src/github.com/monzo/wearedev/vendor"
end

return config
