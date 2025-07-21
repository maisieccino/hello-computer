if vim.fn.isdirectory(vim.fn.expand("~/src/github.com/monzo")) == 0 then
  return {}
end

-- Treat anything containing these files as a root directory. This
-- prevents us ascending too far toward the root of the repository, which
-- stops us from trying to ingest too much code.
local local_root_dir = function(startpath)
  local root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" }
  local matches = vim.fs.find(root_markers, {
    path = startpath,
    upward = true,
    limit = 1,
  })

  -- If there are no matches, fall back to finding the Git ancestor.
  if #matches == 0 then
    return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
  end

  local root_dir = vim.fn.fnamemodify(matches[1], ":p:h")
  return root_dir
end

-- Run goimports on save, fix vendor appearing in path.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()

    -- Remove vendor prefixes
    vim.cmd("silent! %s/github.com\\/monzo\\/wearedev\\/vendor\\///g")

    local params = vim.lsp.util.make_range_params()
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
      registries = {
        "github:mason-org/mason-registry",
        "file:" .. vim.fn.stdpath("config") .. "/mason",
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
    "nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          analyses = {
            fieldalignment = true,
            nilness = true,
            shadow = true,
            unusedparams = true,
            unusedwrite = true,
          },
          cmd = { "env", "GO111MODULE=off", "gopls", "-remote=auto" },

          flags = {
            -- gopls is a particularly slow language server, especially in wearedev.
            -- Debounce text changes so that we don't send loads of updates.
            debounce_text_changes = 200,
          },

          expandWorkspaceToModule = false,
          ["local"] = "github.com/monzo/wearedev",
          root_dir = local_root_dir,

          init_options = {
            codelenses = {
              generate = true,
              gc_details = true,
              test = true,
              tidy = true,
            },
          },

          directory_filters = {
            "-vendor",
            "-manifests",
          },

          -- Never use wearedev as a root path. It'll grind your machine to a halt.
          ignoredRootPaths = { "$HOME/src/github.com/monzo/wearedev/" },
          -- Collect less information about packages without open files.
          memoryMode = "DegradeClosed",
          staticcheck = true,
        },
        vtsls = {
          root_dir = local_root_dir,
          -- Never use wearedev as a root path. It'll grind your machine to a halt.
          ignoredRootPaths = { "$HOME/src/github.com/monzo/wearedev/" },
        },
        bzl = {
          filetypes = { "starlark", "bzl" },
          root_dir = local_root_dir,
        },
        protols = {
          filetypes = { "proto" },
          cmd = {
            "protols",
            "--include-paths="
              .. vim.env.GOPATH
              .. "/src,"
              .. vim.env.GOPATH
              .. "/src/github.com/monzo/wearedev/vendor",
          },
        },
        yamlls = {
          filetypes = { "yaml", "promql" },
        },
      },
    },
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
    },
    config = function()
      vim.treesitter.language.register("starlark", "starlark")
    end,
  },
}
