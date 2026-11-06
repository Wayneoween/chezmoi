---@diagnostic disable: undefined-global
-- Core editor plugins. Language-specific ones live in plugins/lang.lua.
return {
  ---------------------------------------------------------------------------
  -- Look ------------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  ---------------------------------------------------------------------------
  -- Start screen (only the dashboard module of snacks.nvim is enabled) ------
  ---------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    opts = {
      dashboard = {
        enabled = true,
        width = 60,
        preset = {
          -- the dashboard's own buttons open our mini.pick pickers
          pick = function(cmd, opts)
            opts = opts or {}
            if cmd == "files" then
              MiniPick.builtin.files(nil, { source = { cwd = opts.cwd } })
            elseif cmd == "live_grep" then
              MiniPick.builtin.grep_live(nil, { source = { cwd = opts.cwd } })
            elseif cmd == "oldfiles" then
              MiniExtra.pickers.oldfiles()
            end
          end,
          keys = {
            { icon = "\u{f002} ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "\u{f067} ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "\u{f0c5} ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "\u{f1da} ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
            { icon = "\u{f04b2} ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = "\u{f0ad} ", key = "M", desc = "Mason", action = ":Mason" },
            { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          -- left pane
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = "\u{f15b} ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, limit = 5 },
          { icon = "\u{f07b} ", title = "Projects", section = "projects", indent = 2, padding = 1, limit = 5 },
          { section = "startup" },
          -- right pane (stacks below on narrow windows)
          { pane = 2, section = "terminal", cmd = [[cbonsai -p -L 40 | perl -pe 's/\e\[3-1m//g']], height = 20, ttl = 0, padding = 1 }, -- new tree every start; perl strips an invalid color code cbonsai emits
          { pane = 2, icon = "\u{f0599} ", title = "Weather", section = "terminal", cmd = "curl -s -m 3 'wttr.in/?0Q'", height = 5, ttl = 60 * 60, indent = 2, padding = 1 },
          {
            pane = 2,
            icon = "\u{f1d3} ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            ttl = 5 * 60,
            indent = 3,
            padding = 1,
          },
        },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- mini.nvim: icons, statusline, tabline, pairs, picker, file explorer ----
  ---------------------------------------------------------------------------
  {
    "nvim-mini/mini.nvim",
    lazy = false,
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      require("mini.statusline").setup()
      require("mini.tabline").setup()
      require("mini.pairs").setup()
      require("mini.bufremove").setup()
      require("mini.pick").setup()
      require("mini.extra").setup()
      require("mini.files").setup()
      vim.ui.select = MiniPick.ui_select
    end,
  },

  -- shows available keys after pressing <leader> (or any prefix) and waiting
  { "folke/which-key.nvim", event = "VeryLazy", opts = { preset = "helix" } },

  ---------------------------------------------------------------------------
  -- Completion ------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- same feel as NvChad: <Tab>/<S-Tab> to move, <CR> to accept
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      completion = { documentation = { auto_show = true } },
    },
  },

  {
    "github/copilot.vim",
    lazy = false,
    init = function()
      vim.g.copilot_no_tab_map = true -- <Tab> belongs to blink.cmp
      vim.g.copilot_workspace_folders = { "~/code/ansible", "~/code/terraform", "~/code/wildfireservice" }
    end,
    config = function()
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', { expr = true, replace_keycodes = false, desc = "Copilot accept" })
    end,
  },

  ---------------------------------------------------------------------------
  -- Treesitter ------------------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "comment", "gitattributes", "gitignore", "go", "gomod", "gosum", "gotmpl", "gowork", "hcl",
        "json", "lua", "markdown", "markdown_inline", "python", "rust", "sql", "terraform", "yaml",
      }
      local no_highlight = { markdown = true } -- filetypes to keep on regex syntax
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if no_highlight[vim.bo[ev.buf].filetype] then
            vim.treesitter.stop(ev.buf) -- the built-in markdown ftplugin starts it
            return
          end
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPost" },

  ---------------------------------------------------------------------------
  -- Git -------------------------------------------------------------------
  ---------------------------------------------------------------------------
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = { current_line_blame = true } },

  ---------------------------------------------------------------------------
  -- Mason: installs LSP servers and tools ----------------------------------
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    event = "VeryLazy",
    opts = {
      ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
      -- mason package names (see :Mason). Servers are enabled in configs/lsp.lua.
      ensure_installed = {
        -- LSP servers
        "ansible-language-server",
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gitlab-ci-ls",
        "gopls",
        "helm-ls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "python-lsp-server",
        "terraform-ls",
        "vim-language-server",
        "yaml-language-server",
        -- formatters / linters / Go helpers
        "gofumpt",
        "goimports",
        "gomodifytags",
        "impl",
        "markdownlint",
        "shellcheck",
        "shfmt",
        "yamllint",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require "mason-registry"
      registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, pkg = pcall(registry.get_package, tool)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lsp"
    end,
  },

  ---------------------------------------------------------------------------
  -- Formatting & linting --------------------------------------------------
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo", "FormatEnable", "FormatDisable" },
    keys = {
      {
        "<leader>cf",
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify((vim.b.disable_autoformat and "Disabled" or "Enabled") .. " autoformat for current buffer")
        end,
        desc = "Toggle autoformat (buffer)",
      },
      {
        "<leader>cF",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify((vim.g.disable_autoformat and "Disabled" or "Enabled") .. " autoformat globally")
        end,
        desc = "Toggle autoformat (global)",
      },
    },
    opts = require "configs.conform",
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        vim[args.bang and "b" or "g"].disable_autoformat = true
      end, { desc = "Disable autoformat-on-save (! = buffer only)", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable autoformat-on-save" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require "lint"
      -- nvim-lint splits compound filetypes on ".", so `yaml` also covers yaml.ansible etc.
      lint.linters_by_ft = { markdown = { "markdownlint" }, yaml = { "yamllint" } }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
      lint.try_lint()
    end,
  },
}
