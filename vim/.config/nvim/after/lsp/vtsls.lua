local util = require("util")

if not util.is_work() then
  return {}
end

return {
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
  -- Never use wearedev as a root path. It'll grind your machine to a halt.
  ignoredRootPaths = { "$HOME/src/github.com/monzo/wearedev/" },
  root_dir = util.local_root_dir,
}
