local util = require("util")

if not util.is_work() then
  return {}
end

-- @type vim.lsp.Config
return {
  settings = {
    project_id = "monzo-analytics",
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false
  end,
}
