-- enable lsp servers from lsp directory
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    local server_configs = vim
      .iter(vim.api.nvim_get_runtime_file("after/lsp/*.lua", true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ":t:r")
      end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

-- Custom LSP Actions
local on_attach = function(client, bufnr)
  ---@param mode "n"|"i"|"v"
  ---@param l string
  ---@param r fun(any?)|string
  ---@param opts vim.keymap.set.Opts
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, { desc = "LSP Hover" })

  map("n", "<localleader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
  map("n", "<space>wd", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
end

--TODO: Some other interesting ideas here:
--https://github.com/jdhao/nvim-config/blob/a8a1b929212c9d2a015a14215dd58d94bc7bdfe8/lua/config/lsp.lua#L32

---@type vim.lsp.Config
local global_config = {
  on_attach = on_attach,
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
      hover = {
        border = "rounded",
      },
      signatureHelp = {
        border = "rounded",
      },
    },
  },
}

vim.lsp.config("*", global_config)
