return {
  {
    "nvim-lspconfig",
  },
  {
    "nvim-mini/mini.surround",
    opts = {
      -- Fix surround keymapping
      mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",
      },
    },
  },
  {
    "outline.nvim",
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
  },
  {
    "blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
      "onsails/lspkind.nvim",
    },
    opts = {
      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "git", "path", "snippets", "buffer" },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            enabled = function()
              return vim.tbl_contains({ "octo", "gitcommit" }, vim.bo.filetype)
            end,
            opts = {},
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
      completion = {
        menu = {
          draw = {
            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            columns = { { "kind_icon", "label" } },
            padding = { 0, 1 }, -- padding only on right side
            components = {
              kind_icon = {
                ---@param ctx blink.cmp.DrawItemContext
                text = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, _ = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return " " .. mini_icon .. " " .. ctx.icon_gap
                    end
                  end

                  local icon = require("lspkind").symbolic(ctx.kind)
                  return " " .. icon .. " " .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from mini.icons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                ---@param ctx blink.cmp.DrawItemContext
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return mini_hl
                    end
                  end
                  return ctx.kind_hl
                end,
              },
              kind = {
                -- Optional, use highlights from mini.icons
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return mini_hl
                    end
                  end
                  return ctx.kind_hl
                end,
              },
            },
          },
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "<leader>V", "<Plug>(comment_toggle_blockwise_current)", mode = "n", desc = "Comment" },
      { "<leader>V", "<Plug>(comment_toggle_blockwise_visual)", mode = "x", desc = "Comment" },
    },
    opts = function(_, opts)
      local ok, tcc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        opts.pre_hook = tcc.create_pre_hook()
      end
    end,
  },

  {
    "nvim-mini/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { '<leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'Erase Whitespace' },
    },
    opts = {},
  },
  -- Hint and fix deviating indentation
  {
    "tenxsoydev/tabs-vs-spaces.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
