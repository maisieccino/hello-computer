local util = require("util")

if not util.is_work() then
  local loc = LazyVim.get_pkg_path("astro-language-server", "/node_modules/@astrojs/ts-plugin")
  ---@type vim.lsp.Config
  return {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@astrojs/ts-plugin",
              location = loc,
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
    },
  }
end

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio", "--jsx" },
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
  -- Never use wearedev as a root path. It'll grind your machine to a halt.
  ignoredRootPaths = { "$HOME/src/github.com/monzo/web-projects/" },
  root_dir = util.local_root_dir,
  --   root_dir = function(bufnr, on_dir)
  --   -- The project root is where the LSP can be started from
  --   -- As stated in the documentation above, this LSP supports monorepos and simple projects.
  --   -- We select then from the project root, which is identified by the presence of a package
  --   -- manager lock file.
  --   local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  --   -- Give the root markers equal priority by wrapping them in a table
  --   root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
  --     or vim.list_extend(root_markers, { '.git' })
  --   -- We fallback to the current working directory if no project root is found
  --   local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
  --
  --   on_dir(project_root)
  -- end,
}
