return {
  {
    "folke/noice.nvim",
    keys = {
      {
        "<leader>N",
        function()
          vim.notify("test message", vim.log.levels.INFO, {
            secret = "hello",
          })
          vim.notify("test message", vim.log.levels.INFO, {})
        end,
        desc = "Test notification",
      },
    },
    opts = {
      views = {
        bq_info = {
          view = "mini",
          format = {
            {
              "{message}",
              hl_group = "MsgArea",
            },
          },
        },
        bq_ok = {
          view = "mini",
          format = {
            {
              "󰸞",
              hl_group = "DiagnosticVirtualTextHint",
            },
            {
              " {message}",
              hl_group = "DiagnosticVirtualTextHint",
            },
          },
        },
        bq_error = {
          view = "mini",
          format = {
            {
              "",
              hl_group = "DiagnosticVirtualTextError",
            },
            {
              " {message}",
              hl_group = "DiagnosticVirtualTextError",
            },
          },
        },
      },
      routes = {
        {
          filter = {
            event = "notify",
            cond = function(message)
              return message.opts.bq_status == "in_progress"
            end,
          },
          view = "bq_info",
        },
        {
          filter = {
            event = "notify",
            cond = function(message)
              return message.opts.bq_status == "error"
            end,
          },
          view = "bq_error",
        },
        {
          filter = {
            event = "notify",
            cond = function(message)
              return message.opts.bq_status == "ok"
            end,
          },
          view = "bq_ok",
        },
        {
          filter = {
            event = "notify",
            cond = function(message)
              return message.opts.secret ~= nil
            end,
          },
          view = "bq_ok",
        },
      },
    },
  },
}
