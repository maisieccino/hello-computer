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

M.bytes_to_human_readable = function(input)
  local suffix = { "b", "k", "M", "G", "T", "P", "E" }
  local fsize = tonumber(input)
  fsize = (fsize < 0 and 0) or fsize
  if fsize < 1024 then
    return fsize .. suffix[1]
  end
  local i = math.floor((math.log(fsize or 0) / math.log(1024)))
  return string.format("%.2f%s", fsize / math.pow(1024, i), suffix[i + 1])
end

M.bigquery_get_query_size = function()
  if vim.fn.executable("bq") == 0 then
    vim.notify("bq not installed", vim.log.levels.ERROR, {
      bq_status = "error",
    })
    return
  end
  vim.notify("Calculating...", vim.log.levels.INFO, {
    bq_status = "in_progress",
  })
  local lines = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false)
  vim.system({
    "sh",
    "-c",
    "bq query --format=prettyjson --dry_run",
  }, {
    stdin = lines,
  }, function(output)
    if output.code ~= 0 then
      vim.notify("Error from bq: " .. output.stdout, vim.log.levels.ERROR, {
        bq_status = "error",
      })
      return
    end
    local ok, obj = pcall(vim.json.decode, output.stdout, { luanil = { object = true, array = true } })
    if not ok then
      vim.notify("Error parsing result", vim.log.levels.ERROR, {
        bq_status = "error",
      })
      return
    end
    local bytes = vim.tbl_get(obj, "statistics", "query", "totalBytesProcessed")
    if bytes ~= "" then
      vim.notify("Query will process " .. M.bytes_to_human_readable(bytes), vim.log.levels.INFO, {
        bq_status = "ok",
      })
    else
      vim.notify("Could not run bigquery", vim.log.levels.ERROR, {
        bq_status = "error",
      })
    end
  end)
end
return M
