-- if vim.fn.isdirectory(vim.fn.expand("~/src/github.com/monzo")) == 1 then
--   return {}
-- end

return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown", "python" },
    dependencies = {
      "jmbuhr/otter.nvim",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "all",
        languages = { "r", "python", "julia", "bash", "html", "sql" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    keys = function()
      return {
        {
          "<localleader>qr",
          function()
            require("quarto.runner").run_cell()
          end,
          desc = "Run cell",
          silent = true,
        },
        {
          "<localleader>qa",
          function()
            require("quarto.runner").run_above()
          end,
          desc = "Run cell and above",
          silent = true,
        },
        {
          "<localleader>qA",
          function()
            require("quarto.runner").run_above()
          end,
          desc = "Run all",
          silent = true,
        },
        {
          "<localleader>ql",
          function()
            require("quarto.runner").run_line()
          end,
          desc = "Run line",
          silent = true,
        },
        {
          "<localleader>qp",
          "<cmd>QuartoPreview<CR>",
          desc = "Show preview",
          silent = true,
        },
      }
    end,
  },
  {
    "3rd/image.nvim",
    ft = function()
      if vim.api.nvim_buf_get_name(0):match(".*ipynb") then
        return { "quarto", "markdown", "python" }
      end
      return { "quarto", "python" }
    end,
    opts = {
      backend = "kitty",
      integrations = {
        markdown = { enabled = false },
      },
    },
  },
  {
    "benlubas/molten-nvim",
    ft = function()
      if vim.api.nvim_buf_get_name(0):match(".*ipynb") then
        return { "quarto", "markdown", "python" }
      end
      return { "quarto", "python" }
    end,
    dependencies = { "3rd/image.nvim" },
    config = function()
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
    end,
    keys = {
      { "<localleader>q ", ":noautocmd MoltenEnterOutput<CR>", desc = "Open output window" },
      { "<localleader>qi", ":noautocmd MoltenInit ir<CR>", desc = "Start molten kernel (ir)" },
      { "<localleader>qP", ":noautocmd MoltenInit python3<CR>", desc = "Start molten kernel (python3)" },
      { "<localleader>qI", ":noautocmd MoltenInit<CR>", desc = "Start molten kernel" },
      { "<localleader>qe", ":noautocmd MoltenEvaluateOperator<CR>", desc = "Molten: Evaluate" },
    },
  },
  {
    "nvim-lspconfig",
    ft = "quarto",
    opts = {
      servers = {
        r_language_server = {
          enabled = true,
          mason = false,
        },
      },
    },
  },
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html" },
        modules = {},
        ignore_install = {},
        auto_install = true,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          move = {
            enable = true,
            set_jumps = false, -- you can change this if you want.
            goto_next_start = {
              --- ... other keymaps
              ["]s"] = { query = "@code_cell.inner", desc = "next code block" },
            },
            goto_previous_start = {
              --- ... other keymaps
              ["[s"] = { query = "@code_cell.inner", desc = "previous code block" },
            },
          },
          select = {
            enable = true,
            lookahead = true, -- you can change this if you want
            keymaps = {
              --- ... other keymaps
              ["is"] = { query = "@code_cell.inner", desc = "in block" },
              ["as"] = { query = "@code_cell.outer", desc = "around block" },
            },
          },
        },
      })
    end,
  },
}
