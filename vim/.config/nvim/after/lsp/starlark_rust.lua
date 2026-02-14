local util = require("util")

if not util.is_work() then
  return {}
end

return {
  filetypes = { "star", "bzl", "BUILD.bazel", "starlark" },
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
}
