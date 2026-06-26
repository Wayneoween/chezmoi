---@diagnostic disable: undefined-global

-- Filetype config --
vim.api.nvim_create_autocmd("FileType", {
  pattern = "caddyfile",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})
-- terraform --
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars", "*.tftpl" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
-- ansible --
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/ansible/hosts/*.yml",
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})
-- docker-compose --
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "compose.yml",
    "compose.yaml",
    "docker-compose.yml",
    "docker-compose.yaml",
    "docker-compose.*.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})
-- gitlab-ci --
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    ".gitlab-ci.yml",
  },
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})
-- technically the better solution to above, but it's not working
vim.filetype.add {
  pattern = {
    [".gitlab-ci.yml"] = "yaml.gitlab",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.*.yaml"] = "yaml.docker-compose",
    ["*/ansible/hosts/*.yml"] = "yaml.ansible",
    ["openapi.*%.ya?ml"] = "yaml.openapi",
    ["openapi.*%.json"] = "json.openapi",
  },
}
-- golang auto import --
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  end,
})
