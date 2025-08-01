local path = require("plenary.path")
return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  ft = "markdown",
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
      folder = "000 Daily Notes",
      date_format = "%Y-%m-%d",
      template = "Daily Note",
    },
    new_notes_location = "400 Ideas",
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
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    attachments = {
      img_folder = "assets/images",
      img_name_func = function()
        return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
      end,
      confirm_img_paste = true,
    },
  },
}
