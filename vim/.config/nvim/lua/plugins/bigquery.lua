if vim.fn.isdirectory(vim.fn.expand("~/src/github.com/monzo")) == 0 then
  return {}
end

return {
  {
    "kitagry/bqls.nvim",
    ft = "sql",
    dependencies = { "nvim-lspconfig" },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = { "kitagry/bqls.nvim" },
  --   init = function()
  --     require("lspconfig").bqls.setup({
  --       settings = {
  --         project_id = "monzo-analytics",
  --       },
  --       -- This disables the bqls formatter which is very annoying!
  --       on_init = function(client)
  --         client.server_capabilities.documentFormattingProvider = false
  --         client.server_capabilities.documentFormattingRangeProvider = false
  --       end,
  --     })
  --   end,
  -- },
}
