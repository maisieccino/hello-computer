return {
  {
    "folke/snacks.nvim",
    priority = 10000,
    recommended = true,
    lazy = false,
    keys = {
      {
        "<localleader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer (Root dir)",
      },
      {
        "<localleader>a",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Reveal in explorer",
      },
      {
        "<localleader>s",
        function()
          Snacks.picker.pick({
            source = "Services",
            format = "text",
            layout = {
              preset = "default",
            },
            finder = function(config, ctx)
              local cmd = vim.fn.expand("~/bin/projects.sh")
              return require("snacks.picker.source.proc").proc({
                config,
                {
                  cmd = cmd,
                  transform = function(item)
                    item.file = item.text
                    item.text = vim.fs.basename(item.text)
                    return item
                  end,
                },
              }, ctx)
            end,
            ---@type table<string, snacks.picker.Action.spec> actions used by keymaps
            actions = {
              open_in_new_tab = {
                action = function(picker, item, _)
                  picker:close()
                  vim.schedule(function()
                    vim.cmd("tabnew " .. item.file .. "/README.md")
                    Snacks.explorer({ cwd = item.file })
                  end)
                end,
              },
            },
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "open_in_new_tab",
                    mode = { "n", "i" },
                  },
                },
              },
            },
            confirm = function(picker, item, action)
              if action and action.name or "confirm" then
                picker:close()
                vim.schedule(function()
                  vim.fn.bufadd(item.file)
                  Snacks.explorer({ cwd = item.file })
                end)
              end
            end,
          })
        end,
        desc = "Find service",
      },
    },
    opts = {
      -- @type snacks.Config
      picker = {
        win = {
          input = {
            keys = {
              ["<c-t>"] = { "tab", mode = { "n", "i" } },
            },
          },
        },
        sources = {
          explorer = {
            win = {
              input = {
                keys = {
                  ["<C-t>"] = { "tab", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<C-t>"] = "tab",
                },
              },
            },
            layout = {
              hidden = { "input" },
              preview = false,
            },
            auto_close = true,
            follow_file = true,
            hidden = true,
          },
        },
      },
      ---@type snacks.image.Config
      image = {
        enabled = true,
        img_dirs = { "img", "images", "assets", "Assets", "static", "public", "media", "attachments", "assets/images" },
      },
    },
  },
}
