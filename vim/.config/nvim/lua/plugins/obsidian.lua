local util = require("util")

local function sync_notes()
  vim.schedule(function()
    vim.notify("Syncing with git...")
    local cmd = vim.system({ "zsh", vim.fn.expand("./bin/syncnotes.zsh") }, {}, function(out)
      if out.code == 0 then
        vim.notify("Sync complete.")
      else
        vim.notify("Sync failed.", "error")
      end
    end)
  end)
end

return {
  {
    "blink.cmp",
    opts = {
      sources = {
        providers = {
          lsp = {
            -- Disable markdown autocomplete since we use Obsidian's own
            -- autocomplete instead.
            enabled = function()
              return (not vim.tbl_contains({ "markdown" }, vim.bo.filetype))
                or (vim.api.nvim_buf_get_name(0):match("ipynb"))
            end,
          },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    ft = "markdown",
    dependencies = { "obsidian-nvim/obsidian.nvim" },
    ---@type snacks.Config
    opts = {
      image = {
        ---@param path any
        ---@param src any
        ---@return string|nil
        resolve = function(path, src)
          if string.match(src, "^https://") then
            return nil
          end
          local status, obsidian = pcall(require, "obsidian.api")
          if status and obsidian.path_is_note(path) then
            if vim.fn.filereadable(src) == 1 then
              return src
            end
            local dirname = util.git_root_dir(path)
            local filename = vim.fn.fnamemodify(src, ":t")
            local matches = vim.fs.find(filename, {
              path = dirname .. "/Assets",
              limit = 1,
            })
            if #matches == 0 then
              return ""
            else
              return matches[1]
            end
          end
        end,
        enabled = true,
      },
    },
  },
  --       ---@class snacks.image.convert.Config
  --       convert = {
  --         magick = {
  --           default = {
  --             "{src}[0]",
  --             "-scale",
  --             "1920x1080>",
  --             "-grayscale",
  --             "average",
  --             "-fill",
  --             "#83eaea",
  --             "-tint",
  --             "170",
  --             "-fuzz",
  --             "15%",
  --             "-fill",
  --             "none",
  --             "-transparent",
  --             "white",
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    -- @type fun(LazyPlugin):boolean
    cond = function()
      return string.match(vim.fn.getcwd(), "notes")
    end,
    keys = {
      { "<localleader>ot", "<cmd>Obsidian today<CR>", desc = "Daily note (today)" },
      { "<localleader>o+", "<cmd>Obsidian tomorrow<CR>", desc = "Daily note (tomorrow)" },
      { "<localleader>o-", "<cmd>Obsidian yesterday<CR>", desc = "Daily note (yesterday)" },
      { "<localleader>on", "<cmd>Obsidian new<CR>", desc = "New" },
      { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename" },
      { "<localleader>oP", "<cmd>Obsidian paste_img<CR>", desc = "Paste image" },
      { "<localleader>oT", "<cmd>Obsidian tags<CR>", desc = "Tags" },
      { "<localleader>om", "<cmd>Obsidian template<CR>", desc = "Insert template" },
      { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks" },
      { "<localleader>oc", "<cmd>Obsidian toc<CR>", desc = "Insert ToC" },
      { "<localleader>ox", "<cmd>Obsidian extract_note<CR>", desc = "Extract note", mode = "v" },
      { "<localleader>o ", sync_notes, desc = "Push notes to remote" },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/github.com/maisieccino/notes",
        },
      },
      ui = { enable = false },
      daily_notes = {
        folder = "600 Daily Notes",
        date_format = "%Y/%m/%Y-%m-%d",
        template = "Daily Note",
      },
      new_notes_location = "current_dir",
      frontmatter = {
        func = function(note)
          -- Add the title of the note as an alias.
          if note.title then
            note:add_alias(note.title)
          end

          local out = { id = note.id, aliases = note.aliases, tags = note.tags }

          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          return out
        end,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function.
        -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
        -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
        substitutions = {},

        -- A map for configuring unique directories and paths for specific templates
        --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
        customizations = {},
      },
      attachments = {
        folder = "Assets/images",
        img_name_func = function()
          return string.format("pasted_image_%s", os.date("%Y%m%d%H%M%S"))
        end,
        confirm_img_paste = true,
      },
      note_id_func = function(title)
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,
      preferred_link_style = "wiki",
      wiki_link_func = "use_alias_only",
      completion = {
        blink = true,
      },
      picker = {
        name = "snacks.pick",
      },
    },
  },
}
