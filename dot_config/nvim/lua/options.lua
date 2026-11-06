---@diagnostic disable: undefined-global
local o, opt = vim.o, vim.opt

o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"
o.winborder = "rounded"

-- indenting
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

o.number = true
o.numberwidth = 2
o.ruler = false
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
opt.whichwrap:append "<>[]hl"
o.modeline = false

-- folding
o.foldmethod = "indent"
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- mason binaries on PATH from the start (mason itself loads lazily)
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH

vim.diagnostic.config { virtual_text = true, severity_sort = true }

-- cd to the project root (replaces nvim-rooter)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end
    local root = vim.fs.root(ev.buf, { ".git", ".hg", ".svn", "Makefile", "package.json" })
    if root and root ~= vim.fn.getcwd() then
      vim.fn.chdir(root)
    end
  end,
})
