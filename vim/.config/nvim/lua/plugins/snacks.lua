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
          local function list_projects()
            local projects_raw = vim.fn.system(vim.fn.expand("~/bin/projects.sh"))
            local projects = {}
            for project in projects_raw:gmatch("[^\r\n]+") do
              table.insert(projects, { text = project })
            end
            return projects
          end
          local projects = list_projects()
          Snacks.picker.pick({
            source = "Services",
            items = projects,
            format = "text",
            layout = {
              preset = "default",
            },
            confirm = function(picker, item)
              picker:close()
              vim.cmd("e " .. item.text)
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
