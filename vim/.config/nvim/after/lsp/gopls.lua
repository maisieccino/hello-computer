local util = require("util")

local base_cfg = {
  analyses = {
    fieldalignment = true,
    nilness = true,
    shadow = true,
    unusedparams = true,
    unusedwrite = true,
  },
  flags = {
    -- gopls is a particularly slow language server, especially in wearedev.
    -- Debounce text changes so that we don't send loads of updates.
    debounce_text_changes = 200,
  },
  init_options = {
    annotations = {
      bounds = false,
      escape = false,
      inline = false,
    },
    codelenses = {
      generate = true,
      gc_details = true,
      test = true,
      tidy = true,
    },
  },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  staticcheck = true,
}

if util.is_work() then
  return vim.tbl_deep_extend("force", base_cfg, {
    cmd = { "env", "GO111MODULE=off", "gopls", "-remote=auto" },

    expandWorkspaceToModule = false,
    ["local"] = "github.com/monzo/wearedev",
    root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
    root_dir = util.local_root_dir,

    directory_filters = {
      "-vendor",
      "-manifests",
    },

    -- Never use wearedev as a root path. It'll grind your machine to a halt.
    ignoredRootPaths = { "$HOME/src/github.com/monzo/wearedev/" },
    -- Collect less information about packages without open files.
    memoryMode = "DegradeClosed",
    staticcheck = true,
  })
else
  return base_cfg
end
