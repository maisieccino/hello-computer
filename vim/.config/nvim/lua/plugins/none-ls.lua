local null_ls = require("null-ls")

local h = require("null-ls.helpers")
---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
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
    end,
  },
}
