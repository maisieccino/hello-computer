local util = require("util")

if not util.is_work() then
  local loc = LazyVim.get_pkg_path("astro-language-server", "/node_modules/@astrojs/ts-plugin")
  return {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            name = "@astrojs/ts-plugin",
            location = loc,
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  }
end

return {
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
  -- Never use wearedev as a root path. It'll grind your machine to a halt.
  ignoredRootPaths = { "$HOME/src/github.com/monzo/web-projects/" },
  root_dir = util.local_root_dir,
}
