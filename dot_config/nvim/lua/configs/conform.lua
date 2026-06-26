---@diagnostic disable: undefined-global

local opts = {
  -- https://github.com/stevearc/conform.nvim/blob/master/doc/conform.txt
  formatters_by_ft = {
    -- dockerfile = {},
    -- go = { "gofumpt" }, -- I think the golang plugin already does this
    css = { "prettier" },
    hcl = { "terragrunt_hclfmt" },
    html = { "prettier" },
    json = { "jsonls" },
    lua = { "stylua" },
    python = { "ruff_format" },
    sh = { "shfmt" },
    terraform = { "tofu_fmt" },
    tf = { "tofu_fmt" },
    yaml = {},
    ["yaml.ansible"] = {},
    ["yaml.docker-compose"] = {},
    ["yaml.gitlab"] = {},
    ["yaml.openapi"] = {},
  },
  format_on_save = function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match "vars/users/all%.yml$" then
      return -- skip formatting for this single file
    end
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    local disable_filetypes = {
      json = false,
      dockerfile = true,
    }
    return {
      timeout_ms = 500,
      lsp_fallback = false,
    }
  end,
}

return opts
