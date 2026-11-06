---@diagnostic disable: undefined-global
-- https://github.com/stevearc/conform.nvim/blob/master/doc/conform.txt
-- Conform does ALL format-on-save. Missing formatters are skipped silently;
-- check with :ConformInfo.
return {
  formatters_by_ft = {
    go = { "goimports", "gofumpt" },
    css = { "prettier" },
    hcl = { "terragrunt_hclfmt" },
    html = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    python = { "ruff_format" },
    sh = { "shfmt" },
    terraform = { "tofu_fmt" },
  },
  format_on_save = function(bufnr)
    if vim.api.nvim_buf_get_name(bufnr):match "vars/users/all%.yml$" then
      return
    end
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "never" }
  end,
}
