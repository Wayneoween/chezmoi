-- Minimal Neovim 0.11+ LSP config using new API, shaped like the old style.
---@diagnostic disable: undefined-global

local ok_nv, nv = pcall(require, "nvchad.configs.lspconfig")
local on_attach = ok_nv and nv.on_attach or function() end
local on_init = ok_nv and nv.on_init or function() end
local capabilities = ok_nv and nv.capabilities or vim.lsp.protocol.make_client_capabilities()

local util_ok, util = pcall(require, "lspconfig.util")
if not util_ok then util = {} end

local base = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

local servers = {
  "bashls",
  "dockerls",
  "gitlab_ci_ls",
  "helm_ls",
  "html",
  "jsonls",
  "marksman",
  "pylsp",
  "terraformls",
  "vacuum",
  "vimls",
}

local function setup(name, cfg)
  cfg = cfg and vim.tbl_deep_extend("force", {}, base, cfg) or base
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

-- Simple servers (defaults only)
for _, s in ipairs(servers) do
  setup(s)
end

-- Lua
setup("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      hint = { enable = true, arrayIndex = "Auto", setType = true },
      workspace = { checkThirdParty = false },
    },
  },
})

-- Go
setup("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
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

-- Ansible
setup("ansiblels", {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_dir = util.root_pattern and util.root_pattern("ansible.cfg", ".git") or nil,
})

-- Docker Compose
setup("docker_compose_language_service", {
  filetypes = { "yaml.docker-compose" },
  root_dir = util.root_pattern and util.root_pattern(
    "compose.yaml",
    "compose.yml",
    "docker-compose.yaml",
    "docker-compose.yml"
  ) or nil,
})

-- Example (disabled):
-- setup("yamlls", { settings = { yaml = { } } })
