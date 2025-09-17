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
            confirm = function(picker, item)
              picker:close()
              vim.fn.chdir(item.file)
              Snacks.explorer({ cwd = item.file })
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
      image = {
        enabled = true,
        img_dirs = { "img", "images", "assets", "Assets", "static", "public", "media", "attachments", "assets/images" },
      },
    },
  },
}
