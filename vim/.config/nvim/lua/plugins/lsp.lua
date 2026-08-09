local util = require("util")

local shared = {
  "gopls",
  "marksman",
  "shellcheck",
  "sqlfluff",
  "shfmt",
  "terraform-ls",
  "tombi",
  "vtsls",
  "yaml-language-server",
}

local work = {

  "bqls",
  "protols",
}

local home = {

  "astro-language-server",
  "cssmodules-language-server",
  "css-variables-language-server",
  "r-languageserver",
}

local servers = shared
if util.is_work() then
  servers = vim.tbl_extend("keep", shared, work)
else
  servers = vim.tbl_extend("keep", shared, home)
end

return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = servers,
      ui = {
        border = "rounded",
      },
    },
  },
  {
    -- Disable automated config from Mason.
    "mason-lspconfig.nvim",
    enabled = false,
  },
}
