local util = require("util")

local h = require("null-ls.helpers")

---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function(_, opts)
      local null_ls = require("null-ls")
      table.insert(opts.sources, {
        name = "shellcheck",
        meta = {
          url = "https://www.shellcheck.net/",
          description = "A shell script static analysis tool.",
        },
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "sh" },
        generator = null_ls.generator({
          command = "shellcheck",
          args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
          to_stdin = true,
          format = "json",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(params)
            local parser = h.diagnostics.from_json({
              attributes = { code = "code" },
              severities = {
                info = h.diagnostics.severities["information"],
                style = h.diagnostics.severities["hint"],
              },
            })

            return parser({ output = params.output.comments })
          end,
        }),
      })

      if not util.is_work() then
        table.insert(opts.sources, null_ls.builtins.diagnostics.semgrep)
        table.insert(opts.sources, null_ls.builtins.diagnostics.golangci_lint)
        table.insert(opts.sources, require("none-ls.formatting.golangci_lint"))
      end
    end,
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "golangci-lint",
        "semgrep",
        "shellcheck",
      },
    },
  },
}
