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
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()

    -- Remove vendor prefixes
    vim.cmd("silent! %s/github.com\\/monzo\\/wearedev\\/vendor\\///g")

    local params = vim.lsp.util.make_range_params(0, "utf-8")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})
-- Lsp pretty popups
local border_config = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border_config,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border_config,
})
vim.diagnostic.config({
  signs = false,
  border = true,
  float = { border = border_config },
})

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "semgrep",
      },
      registries = {
        "github:mason-org/mason-registry",
        -- "file:" .. vim.fn.stdpath("config") .. "/mason",
      },
    },
  },
  {
    "sgur/vim-editorconfig",
    enabled = false,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")
      local cwd = vim.fn.getcwd()
      local git_dir = git_root_dir(cwd)
      return {
        debug = true,
        sources = {
          null_ls.builtins.diagnostics.semgrep.with({
            extra_args = {
              "--config=" .. git_dir .. "/static-check-rules",
              "--severity=WARNING",
              "--severity=ERROR",
            },
            timeout = 10000,
            ignore_stderr = true,
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          }),
          null_ls.builtins.diagnostics.buf,
        },
      }
    end,
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
    dependencies = { "nvim-neotest/neotest-jest" },
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
          jestCommand = "yarn test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
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
    end,
  },
  {
    "pwntester/octo.nvim",
    opts = {
      notifications = {
        current_repo_only = true,
      },
    },
  },
}
