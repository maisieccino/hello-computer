local util = require("util")
local Snacks = require("snacks")

-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
  vim.schedule(function()
    local kernels = vim.fn.MoltenAvailableKernels()
    local running_kernels = vim.fn.MoltenRunningKernels()
    local try_kernel_name = function()
      local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
      return metadata.kernelspec.name
    end
    local ok, kernel_name = pcall(try_kernel_name)

    -- If a matching kernel is already running, don't start a new one!
    if ok and vim.tbl_contains(running_kernels, kernel_name) then
      return
    end
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      if venv ~= nil then
        kernel_name = string.match(venv, "/.+/(.+)")
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(("MoltenInit %s"):format(kernel_name))
    end
    vim.cmd("MoltenImportOutput")
    require("quarto").activate()
  end)
end
vim.api.nvim_create_autocmd("BufAdd", {
  pattern = { "*.ipynb" },
  callback = imb,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ipynb" },
  callback = function(e)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
      imb(e)
    end
  end,
})
-- automatically export output chunks to a jupyter notebook on write
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ipynb" },
  callback = function()
    if require("molten.status").initialized() == "Molten" then
      vim.cmd("MoltenExportOutput!")
    end
  end,
})

local function to_obsidian_attachment_path(path, src)
  local dirname = util.git_root_dir(path)
  local filename = vim.fn.fnamemodify(src, ":t")

  local matches = vim.fs.find(filename, {
    path = dirname .. "/Assets",
    limit = 1,
  })
  if #matches == 0 then
    return src
  else
    return matches[1]
  end
end

-- gets images for frontmatter
local function get_imgs()
  local bufnr = vim.api.nvim_get_current_buf()
  local ts = vim.treesitter
  local query = ts.query.parse(
    "markdown",
    [[
((minus_metadata) @frontmatter)
]]
  )
  for _ in query:iter_captures(ts.get_parser():trees()[1]:root(), bufnr) do
    -- Parse yaml
    local fm_query = ts.query.parse(
      "yaml",
      [[
          (block_mapping_pair
            value: (flow_node
            (plain_scalar (string_scalar) @a)
            (#match? @a "\.(jpe?g|png|tiff)$")
            )
          )
        ]]
    )
    local tree = ts.get_parser():children()["yaml"]:trees()[1]
    if tree == nil then
      vim.print("no tree found")
      return
    end

    Snacks.image.placement.clean(bufnr)
    for _, match in fm_query:iter_captures(tree:root(), bufnr) do
      local file_name = ts.get_node_text(match, bufnr)

      local status, obsidian = pcall(require, "obsidian.api")
      local path = vim.api.nvim_buf_get_name(bufnr)
      if status and obsidian.path_is_note(path) then
        -- Resolve obsidian img file
        file_name = to_obsidian_attachment_path(path, file_name)
      end

      local row = match:range(false)
      Snacks.image.placement.new(bufnr, file_name, {
        pos = { row + 1, 0 },
        range = { row + 1, 0, row + 1, 0 },
        inline = true,
        max_height = 20,
        auto_resize = true,
        conceal = false,
      })
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  pattern = { "*.md" },
  callback = get_imgs,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.md" },
  callback = function(opts)
    require("otter").activate({ "markdown", "yaml" })
  end,
  group = vim.api.nvim_create_augroup("md_otter", {}),
})
