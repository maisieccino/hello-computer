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
              return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
            end,
          },
        },
      },
    },
  },
  -- {
  --   "folke/snacks.nvim",
  --   ft = "markdown",
  --   -- @type fun(LazyPlugin):boolean
  --   cond = function()
  --     -- Only apply in Obsidian folder
  --     return string.match(vim.fn.getcwd(), "notes")
  --   end,
  --   -- dependencies = { "obsidian-nvim/obsidian.nvim" },
  --   opts = {
  --     image = {
  --       -- resolve = function(path, src)
  --       --   if require("obsidian.api").path_is_note(path) then
  --       --     return require("obsidian.api").resolve_image_path(src)
  --       --   end
  --       -- end,
  --       enabled = true,
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
    lazy = true,
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
      { "<localleader>o ", "<cmd>!/bin/zsh -c syncnotes<CR>", desc = "Push notes to remote" },
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/github.com/maisieccino/notes",
        },
      },
      ui = { enable = false },
      daily_notes = {
        folder = "600 Daily Notes",
        date_format = "%Y-%m-%d",
        template = "Daily Note",
      },
      new_notes_location = "current_dir",
      note_frontmatter_func = function(note)
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
        img_folder = "assets/images",
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
