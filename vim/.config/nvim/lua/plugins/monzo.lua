local util = require("util")

if not util.is_work() then
  return {}
end

local git_root_dir = function(startpath)
  local paths = vim.fs.find(".git", { path = startpath, upward = true })
  if #paths == 0 then
    return vim.fs.dirname(startpath)
  end
  return vim.fs.dirname(paths[1])
end

-- Run goimports on save, fix vendor appearing in path.
-- TODO: May not be needed! https://go-review.googlesource.com/c/tools/+/708475
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = "*.go",
--   callback = function()
--     vim.lsp.buf.format()
--
--     -- Remove vendor prefixes
--     vim.cmd("silent! %s/github.com\\/monzo\\/wearedev\\/vendor\\///g")
--
--     local params = vim.lsp.util.make_range_params(0, "utf-8")
--     params.context = { only = { "source.organizeImports" } }
--     local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
--     for cid, res in pairs(result or {}) do
--       for _, r in pairs(res.result or {}) do
--         if r.edit then
--           local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--           vim.lsp.util.apply_workspace_edit(r.edit, enc)
--         end
--       end
--     end
--   end,
-- })
vim.diagnostic.config({
  signs = false,
  border = true,
  float = { border = "rounded" },
})

---@type LazySpec[]
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "semgrep",
      },
      registries = {
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    "sgur/vim-editorconfig",
    enabled = false,
  },
  {
    "editorconfig/editorconfig-vim",
    lazy = false,
    init = function()
      vim.g.editorconfig_verbose = 1
      vim.g.editorconfig_blacklist = {
        filetype = {
          "git.*",
          "fugitive",
          "help",
          "lsp-.*",
          "any-jump",
          "gina-.*",
        },
        pattern = { "\\.un~$" },
      }
    end,
  },
  {
    "neotest",
    dependencies = { "nvim-neotest/neotest-jest", "nvim-treesitter" },
    commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
    opts = {
      discovery = {
        enabled = false,
        concurrent = 1,
      },
      running = {
        concurrent = 1,
      },
      summary = {
        animated = 1,
      },
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "yarn test",
          jestConfigFile = function(file)
            return git_root_dir(file) .. "/jest.config.js"
          end,
          jest_test_discovery = true,
          env = { CI = true },
          cwd = function(file)
            if file:find("/packages/") then
              -- Matches "some/path/" in "some/path/src/"
              local match = file:match("(.*/[^/]+/)src")

              if match then
                return match
              end
            end
            return vim.fn.getcwd()
          end,
          isTestFile = function(file_path)
            if not file_path then
              return false
            end
            return require("neotest-jest.jest-util").defaultIsTestFile(file_path)
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = { "starlark" },
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
    init = function()
      vim.treesitter.language.register("starlark", "starlark")
      vim.treesitter.language.register("tsx", "typescriptreact")
    end,
  },
  {
    "octo.nvim",
    opts = {
      notifications = {
        current_repo_only = true,
      },
    },
  },
}
