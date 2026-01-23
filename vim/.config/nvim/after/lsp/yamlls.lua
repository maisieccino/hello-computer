local util = require("util")

local base_settings = {
  filetypes = { "yaml", "promql" },
  root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git", "package.json" },
}

if not util.is_work() then
  return base_settings
end

local filename = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
local git_dir = util.git_root_dir(filename)
local ruleslib_schema_path = git_dir .. "/libraries/fincrime/ruleslib/schemas/combined.json"
local keyspace_schema_path = git_dir .. "/libraries/cassandra/schema/schema.bundled.generated.json"

return vim.tbl_deep_extend("force", base_settings, {
  settings = {
    yaml = {
      schemas = {
        [ruleslib_schema_path] = "rules/**/*.yml",
        [keyspace_schema_path] = "service.*/config/schema.yml",
        ["https://json.schemastore.org/semgrep.json"] = "static-check-rules/**/*.{yml,yaml}",
      },
    },
  },
})
