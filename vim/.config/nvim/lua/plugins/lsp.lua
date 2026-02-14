return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "astro-language-server",
        "bqls",
        "cssmodules-language-server",
        "css-variables-language-server",
        "gopls",
        "marksman",
        "protols",
        "r-languageserver",
        "shellcheck",
        "sqlfluff",
        "shfmt",
        "terraform-ls",
        "tombi",
        "vtsls",
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
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "gotmpl", "gowork" } },
  },
}
