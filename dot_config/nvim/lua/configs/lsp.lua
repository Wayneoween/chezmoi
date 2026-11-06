---@diagnostic disable: undefined-global
-- Native 0.11+ LSP setup. nvim-lspconfig only provides the per-server defaults;
-- blink.cmp adds its completion capabilities automatically.

local servers = {
  "ansiblels",
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  "gitlab_ci_ls",
  "gopls",
  "helm_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "pylsp",
  "terraformls",
  "vimls",
}

-- vacuum (OpenAPI linter) isn't in mason: `go install github.com/daveshanley/vacuum@latest`
if vim.fn.executable "vacuum" == 1 then
  table.insert(servers, "vacuum")
end

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      hint = { enable = true, arrayIndex = "Auto", setType = true },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = { unusedparams = true, nilness = true, unusedwrite = true, useany = true },
      completeUnimported = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      gofumpt = true,
      semanticTokens = true,
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config("ansiblels", {
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".git" },
})

vim.lsp.config("docker_compose_language_service", {
  filetypes = { "yaml.docker-compose" },
  root_markers = { "compose.yaml", "compose.yml", "docker-compose.yaml", "docker-compose.yml" },
})

vim.lsp.enable(servers)

-- Inlay hints
vim.lsp.inlay_hint.enable(true)
vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment", default = true })
vim.api.nvim_create_user_command("InlayHintsToggle", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = "Toggle inlay hints on current buffer" })
