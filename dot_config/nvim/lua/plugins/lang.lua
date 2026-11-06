---@diagnostic disable: undefined-global
-- Language/filetype-specific plugins. Each one only loads for its filetype.
return {
  -- Go: struct tags, impl, iferr, tests (gopls does the rest)
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    opts = {},
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  { "mfussenegger/nvim-ansible", ft = "yaml.ansible" },
  { "isobit/vim-caddyfile", ft = "caddyfile" },
  { "rhadley-recurly/vim-terragrunt", ft = "hcl" },

  -- Dockerfile linting
  {
    "immanuwell/droast.nvim",
    ft = "dockerfile",
    config = function()
      require("droast").setup() -- :Droast* commands + on-save lint
      require("droast").lint(0) -- lint the Dockerfile that triggered loading
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dockerfile",
        callback = function(a)
          require("droast").lint(a.buf)
        end,
      })
    end,
  },

  -- community fork; epwalsh/obsidian.nvim is unmaintained
  { "obsidian-nvim/obsidian.nvim", ft = "markdown" },
}
