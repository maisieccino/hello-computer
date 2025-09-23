local M = {}

-- Treat anything containing these files as a root directory. This
-- prevents us ascending too far toward the root of the repository, which
-- stops us from trying to ingest too much code.
M.local_root_dir = function(bufnr, on_dir)
  local startpath = vim.api.nvim_buf_get_name(bufnr)
  local root_markers = { "README.md", "main.go", "go.mod", "LICENSE", ".git" }
  local matches = vim.fs.find(root_markers, {
    path = startpath,
    upward = true,
    limit = 1,
  })

  -- If there are no matches, fall back to finding the Git ancestor.
  if #matches == 0 then
    on_dir(vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1]))
    return
  end

  local root_dir = vim.fn.fnamemodify(matches[1], ":p:h")
  on_dir(root_dir)
end

-- Check for presence of work directory
M.is_work = function()
  return vim.fn.isdirectory(vim.fn.expand("~/src/github.com/monzo")) == 1
end

return M
