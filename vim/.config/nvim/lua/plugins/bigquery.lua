local util = require("util")

if not util.is_work() then
  return {}
end

return {
  {
    "kitagry/bqls.nvim",
    ft = "sql",
    dependencies = { "nvim-lspconfig" },
  },
}
