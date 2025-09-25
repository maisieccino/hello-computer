local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    version = false, -- always use the latest git commit
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  install = {},
  checker = {
    enabled = true,
    notify = false,
  },
  ui = {
    size = { width = 0.8, height = 0.85 },
    border = "rounded",
    wrap = false, -- Wrap UI text
    pills = true,
    icons = {
      git = " ",
      status = {
        git = {
          added = "₊", --  ₊
          modified = "∗", --  ∗
          removed = "₋", --  ₋
        },
        diagnostics = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
        filename = {
          modified = "+",
          readonly = "🔒",
          zoomed = "🔎",
        },
      },
      -- Default completion kind symbols.
      kinds = {
        Array = "󰅪 ", --  󰅪 󰅨 󱃶
        Boolean = "󰨙 ", -- 󰨙 󰔡 󱃙 󰟡  ◩
        Class = "󰌗 ", --  󰌗 󰠱 𝓒
        Codeium = "󰘦 ",
        Collapsed = " ",
        Color = "󰏘 ", --  󰸌 󰏘
        Constant = "󰏿 ", -- 󰏿  
        Constructor = " ", --   
        Control = " ",
        Copilot = " ",
        Enum = "󰕘 ", --   󰕘 ℰ 
        EnumMember = " ",
        Event = " ", --  
        Field = " ", --  󰄶  󰆨  󰀻 󰃒 
        File = " ", --    󰈔 󰈙
        Folder = " ", --   󰉋
        Function = "󰊕 ", -- 󰊕 ƒ 
        Interface = " ", --    
        Key = " ",
        Keyword = " ", --   󰌋 
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ", --  󰟢
        Number = "󰎠 ", -- 󰎠  
        Object = " ", --   󰅩
        Operator = "󰃬 ", --  󰃬 󰆕 +
        Package = " ", --   󰏖 󰏗 󰆧 
        Property = " ", --    󰖷
        Reference = "󰈝 ", --  󰈝 󰈇
        Snippet = "󱄽 ", -- 󱄽   󰘌 ⮡  
        String = " ", --   󰅳
        Struct = "󰆼 ", -- 󰆼   𝓢 󰙅 󱏒
        Supermaven = " ",
        TabNine = "󰏚 ",
        Text = " ", --   󰉿 𝓐
        TypeParameter = " ", --  󰊄 𝙏
        Unit = " ", --   󰑭 
        Value = " ", --  󰀬 󰎠 
        Variable = " ", -- 󰀫  
      },
    },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
