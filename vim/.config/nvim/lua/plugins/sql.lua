local util = require("util")

---@type LazySpec
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = false,
    ft = "sql",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("estimate_query_on_save", {}),
        callback = function()
          if vim.bo.filetype == "sql" then
            util.bigquery_get_query_size()
          end
        end,
      })
    end,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
      {
        "<localleader>qd",
        util.bigquery_get_query_size,
        desc = "Estimate query size",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        sqlfluff = {
          timeout_ms = 1000,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    ft = "sql",
    opts = {
      linters = {
        sqlfluff = {
          args = { "lint", "--format=json" },
        },
      },
    },
  },
}
