return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "astro-language-server",
        "bqls",
        "gopls",
        "marksman",
        "protols",
        "shellcheck",
        "sqlfluff",
        "shfmt",
        "yaml-language-server",
      },
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
