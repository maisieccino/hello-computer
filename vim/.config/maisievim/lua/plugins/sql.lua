local to_human_readable = function(input)
  -- stackoverflow, compute human readable file size
  local suffix = { "b", "k", "M", "G", "T", "P", "E" }
  local fsize = tonumber(input)
  fsize = (fsize < 0 and 0) or fsize
  if fsize < 1024 then
    return fsize .. suffix[1]
  end
  local i = math.floor((math.log(fsize) / math.log(1024)))
  return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
end

local bigquery_get_query_size = function()
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
      vim.notify("Query will process " .. to_human_readable(bytes), vim.log.levels.INFO, {
        bq_status = "ok",
      })
    else
      vim.notify("Could not run bigquery", vim.log.levels.ERROR, {
        bq_status = "error",
      })
    end
  end)
end

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = false,
    ft = "sql",
    config = function()
      group = vim.api.nvim_create_augroup("estimate_query_on_save", {})
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        callback = function()
          if vim.bo.filetype == "sql" then
            bigquery_get_query_size()
          end
        end,
      })
    end,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
      {
        "<localleader>qd",
        bigquery_get_query_size,
        desc = "Estimate query size",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    ft = "sql",
    opts = {
      linters = {
        sqlfluff = {
          args = { "lint", "-" },
        },
      },
    },
  },
}
