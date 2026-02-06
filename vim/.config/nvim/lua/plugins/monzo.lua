local util = require("util")

if not util.is_work() then
  return {}
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

local function neotest_local_root()
  return vim.fn.expand("%:p:h")
  -- local current = vim.fn.expand("%:h")
  --
  -- local matches = vim.fs.find({ "main.go", "README.md" }, {
  --   path = current,
  --   upward = true,
  --   limit = 1,
  -- })
  -- if #matches == 0 then
  --   return current
  -- end
  -- return vim.fn.fnamemodify(matches[1], ":p:h")
end

---@type LazySpec[]
return {
  {
    "pin",
    dir = "/Users/maisiebell/src/github.com/monzo/wearedev-pin/tools/editors/nvim/pin.nvim",
    main = "pin",
    cmd = {
      "ShipperDeploy",
      "GoToProto",
    },
    keys = {
      { "gP", "<cmd>GoToProto<CR>", desc = "Go to Protobuf definition" },
    },
  },
  {
    "neotest",
    dependencies = { "nvim-neotest/neotest-jest", "fredrikaverpil/neotest-golang", "nvim-treesitter" },
    commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
    keys = {
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.fn.expand("%:.:h"))
        end,
        desc = "Run All Test Files in package (Neotest)",
      },
    },
    ---@type neotest.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      discovery = {
        enabled = true,
        concurrent = 1,
        filter_dir = function(name, relpath, root)
          local project_dir = util.git_root_dir(vim.api.nvim_buf_get_name(0))
          return not string.match(relpath, project_dir)
        end,
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
            return util.git_root_dir(file) .. "/jest.config.js"
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
      require("neotest-golang")(
        ---@type NeotestGolangOptions
        {
          filter_dir_patterns = {
            "vendor",
          },
        }
      ),
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
