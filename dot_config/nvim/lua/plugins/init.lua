---@diagnostic disable: undefined-global
return {
  ---------------------------------------------------------------------------
  -- Mason (TOOLS) ---------------------------------------------------------
  ---------------------------------------------------------------------------
  -- Tools/live binaries that are NOT LSP SERVERS belong here. Examples:
  -- formatters, linters, DAP adapters, code generators, etc.
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        -- Go tooling
        "delve", -- DAP
        "gofumpt", -- formatter
        "goimports", -- formatter / imports
        "gomodifytags", -- struct tag helper
        "impl", -- interface implementation generator
        -- Linters / formatters (generic)
        "markdownlint",
        "shellcheck",
        "shfmt",
        "yamllint",
        "yaml-language-server", -- YAML LSP (for yamllint)
      },
    },
    config = function(_, opts)
      local mason = require "mason"
      mason.setup()
      -- Auto-install the declared tools
      local registry = require "mason-registry"
      for _, tool in ipairs(opts.ensure_installed or {}) do
        local ok, pkg = pcall(registry.get_package, tool)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
      -- Filetype customizations
      require "configs.filetype"
    end,
  },
  ---------------------------------------------------------------------------
  -- mason-lspconfig (LSP SERVERS) -----------------------------------------
  ---------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
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
        "pylsp",
        "terraformls",
        "vimls",
        -- NOT adding 'vacuum' here (not provided by mason-lspconfig)
      },
      automatic_installation = true,
    },
  },

  ---------------------------------------------------------------------------
  -- LSP core setup --------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Load NvChad defaults first (capabilities, handlers, etc.)
      require("nvchad.configs.lspconfig").defaults()
      -- Then apply custom 0.11+ API config
      require "configs.lspconfig"
      -- Manual note: if you need the 'vacuum' OpenAPI linter LSP:
      --   go install github.com/daveshanley/vacuum@latest
      -- and ensure the binary is on PATH. It is configured in configs/lspconfig.lua
      -- but not managed by mason-lspconfig.
    end,
  },

  ---------------------------------------------------------------------------
  -- Inlay hints (after LSP attaches) --------------------------------------
  ---------------------------------------------------------------------------
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end,
  },

  ---------------------------------------------------------------------------
  -- Linting ---------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "mfussenegger/nvim-lint" },

  ---------------------------------------------------------------------------
  -- Treesitter & related --------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "comment",
        "gitattributes",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "hcl",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "sql",
        "terraform",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(opts.ensure_installed)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", lazy = false },
  ---------------------------------------------------------------------------
  -- Rooter ----------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "notjedi/nvim-rooter.lua",
    lazy = false,
    config = function()
      require("nvim-rooter").setup()
    end,
  },
  ---------------------------------------------------------------------------
  -- filetype overrides (optional with 0.11) ----------------
  ---------------------------------------------------------------------------
  {
    "nathom/filetype.nvim",
    config = function()
      require("filetype").setup {
        overrides = {
          extensions = {
            tf = "terraform",
            tfvars = "terraform",
            tfstate = "json",
          },
        },
      }
    end,
  },
  ---------------------------------------------------------------------------
  -- Formatting (conform) --------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          if vim.b.disable_autoformat then
            vim.cmd "FormatEnable"
            vim.notify "Enabled autoformat for current buffer"
          else
            vim.cmd "FormatDisable!"
            vim.notify "Disabled autoformat for current buffer"
          end
        end,
        desc = "Toggle autoformat for current buffer",
      },
      {
        "<leader>cF",
        function()
          if vim.g.disable_autoformat then
            vim.cmd "FormatEnable"
            vim.notify "Enabled autoformat globally"
          else
            vim.cmd "FormatDisable"
            vim.notify "Disabled autoformat globally"
          end
        end,
        desc = "Toggle autoformat globally",
      },
    },
    opts = require "configs.conform",
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable autoformat-on-save", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable autoformat-on-save" })
    end,
  },
  ---------------------------------------------------------------------------
  -- Ansible ---------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "mfussenegger/nvim-ansible", ft = "yaml.ansible" },
  ---------------------------------------------------------------------------
  -- Go helper plugins -----------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup {
        lsp_cfg = false, -- using our unified LSP setup
      }
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  ---------------------------------------------------------------------------
  -- Debug Adapter Protocol ------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },
  ---------------------------------------------------------------------------
  -- Caddy -----------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "isobit/vim-caddyfile", ft = { "caddyfile" } },
  ---------------------------------------------------------------------------
  -- Terraform / Terragrunt ------------------------------------------------
  ---------------------------------------------------------------------------
  { "rhadley-recurly/vim-terragrunt", ft = "hcl" },
  ---------------------------------------------------------------------------
  -- Obsidian --------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  ---------------------------------------------------------------------------
  -- Git integrations ------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
  ---------------------------------------------------------------------------
  -- GitHub Copilot --------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_assume_mapped = true
      vim.keymap.del("i", "<Tab>")
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_workspace_folders = {
        "~/code/ansible",
        "~/code/terraform",
        "~/code/wildfireservice",
      }
    end,
  },
}
