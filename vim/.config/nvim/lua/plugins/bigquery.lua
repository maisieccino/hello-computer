local util = require("util")

if not util.is_work() then
  return {}
end

---@type LazySpec[]
return {
  {
    "kitagry/bqls.nvim",
    ft = "sql",
    dependencies = { "nvim-lspconfig" },
    dev = true,
  },
}
