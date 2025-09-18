return {
  -- Pretty window for navigating LSP locations
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    -- stylua: ignore
    keys = {
      { '<leader>cg', '', desc = '+glance' },
      { '<leader>cgd', '<cmd>Glance definitions<CR>', desc = 'Glance Definitions' },
      { '<leader>cgr', '<cmd>Glance references<CR>', desc = 'Glance References' },
      { '<leader>cgy', '<cmd>Glance type_definitions<CR>', desc = 'Glance Type Definitions' },
      { '<leader>cgi', '<cmd>Glance implementations<CR>', desc = 'Glance implementations' },
      { '<leader>cgu', '<cmd>Glance resume<CR>', desc = 'Glance Resume' },
    },
    opts = function()
      local actions = require("glance").actions
      return {
        folds = {
          fold_closed = "󰅂", -- 󰅂 
          fold_open = "󰅀", -- 󰅀 
          folded = true,
        },
        mappings = {
          list = {
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["sg"] = actions.jump_vsplit,
            ["sv"] = actions.jump_split,
            ["st"] = actions.jump_tab,
            ["p"] = actions.enter_win("preview"),
          },
          preview = {
            ["q"] = actions.close,
            ["p"] = actions.enter_win("list"),
          },
        },
      }
    end,
  },
  -- Make folds look modern and keep a high performance
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end },
      { 'zM', function() require('ufo').closeAllFolds() end },
      -- { 'zr', function() require('ufo').openFoldsExceptKinds() end },
      -- { 'zm', function() require('ufo').closeFoldsWith() end },
    },
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      -- lsp->treesitter->indent
      ---@param bufnr integer
      ---@return table
      local function customizeSelector(bufnr)
        local function handleFallbackException(err, providerName)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return require("ufo")
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return handleFallbackException(err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(err, "indent")
          end)
      end

      local ft_providers = {
        vim = "indent",
        python = { "indent" },
        git = "",
        help = "",
        qf = "",
        fugitive = "",
        fugitiveblame = "",
        ["neo-tree"] = "",
      }

      return {
        open_fold_hl_timeout = 0,
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 10,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },

        -- Select the fold provider.
        provider_selector = function(_, filetype, _)
          return ft_providers[filetype] or customizeSelector
        end,

        -- Display text for folded lines.
        ---@param text table
        ---@param lnum integer
        ---@param endLnum integer
        ---@param width integer
        ---@return table
        fold_virt_text_handler = function(text, lnum, endLnum, width)
          local suffix = " 󰇘 "
          local lines = (" 󰁂 %d "):format(endLnum - lnum)

          local cur_width = 0
          for _, section in ipairs(text) do
            cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
          end

          suffix = suffix .. (" "):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

          table.insert(text, { suffix, "UfoFoldedEllipsis" })
          table.insert(text, { lines, "Folded" })
          return text
        end,
      }
    end,
  },
}
