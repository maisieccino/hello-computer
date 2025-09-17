if vim.api.nvim_buf_get_name(0):match(".*ipynb") then
  require("quarto").activate()
end
