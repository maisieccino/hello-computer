local util = require("util")

if not util.is_work() then
  return {}
end

vim.diagnostic.config({
  signs = false,
  border = true,
  float = { border = "rounded" },
})

---@type LazySpec[]
return {
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
        concurrent = true,
      },
      ---@diagnostic disable-next-line: missing-fields
      summary = {
        animated = true,
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
