---@diagnostic disable: undefined-global
-- Same keys as NvChad's defaults, so muscle memory still works.
-- Press <space> and wait to see all <leader> maps (which-key).
local map = vim.keymap.set

-- insert-mode movement
map("i", "jk", "<ESC>")
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
-- <C-l> in insert mode = accept Copilot suggestion (see plugins/init.lua)

-- windows
map("n", "<C-h>", "<C-w>h", { desc = "window left" })
map("n", "<C-l>", "<C-w>l", { desc = "window right" })
map("n", "<C-j>", "<C-w>j", { desc = "window down" })
map("n", "<C-k>", "<C-w>k", { desc = "window up" })

-- general
map("n", ";", ":", { desc = "command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "copy whole file" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "replace word under cursor" })
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "format file" })
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- buffers
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "buffer next" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "buffer prev" })
map("n", "<leader>x", function()
  require("mini.bufremove").delete()
end, { desc = "buffer close" })

-- file explorer (was nvim-tree)
map("n", "<C-n>", function()
  if not require("mini.files").close() then
    require("mini.files").open()
  end
end, { desc = "file explorer toggle" })
map("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "file explorer at current file" })

-- pickers (was telescope)
-- MiniPick.builtin.* first, then MiniExtra.pickers.*
local function pick(name, opts)
  return function()
    (MiniPick.builtin[name] or MiniExtra.pickers[name])(opts)
  end
end
map("n", "<leader>ff", pick "files", { desc = "find files" })
map("n", "<leader>fa", function()
  MiniPick.builtin.cli({ command = { "rg", "--files", "--hidden", "--no-ignore", "--follow" } }, { source = { name = "All files" } })
end, { desc = "find all files (incl. hidden/ignored)" })
map("n", "<leader>fw", pick "grep_live", { desc = "live grep" })
map("n", "<leader>fb", pick "buffers", { desc = "find buffers" })
map("n", "<leader>fh", pick "help", { desc = "help pages" })
map("n", "<leader>fo", pick "oldfiles", { desc = "recent files" })
map("n", "<leader>fz", pick("buf_lines", { scope = "current" }), { desc = "search current buffer" })
map("n", "<leader>ma", pick "marks", { desc = "marks" })
map("n", "<leader>cm", pick "git_commits", { desc = "git commits" })
map("n", "<leader>gt", pick "git_hunks", { desc = "git changes" })
map("n", "<leader>ds", pick "diagnostic", { desc = "diagnostics" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "exit terminal mode" })
map("n", "<leader>h", "<cmd>split | terminal<CR>", { desc = "terminal horizontal" })
map("n", "<leader>v", "<cmd>vsplit | terminal<CR>", { desc = "terminal vertical" })

-- LSP (0.12 also has built-ins: K hover, grn rename, gra actions, grr refs, gri impl, grt type def)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local o = function(desc)
      return { buffer = ev.buf, desc = "LSP " .. desc }
    end
    map("n", "gd", vim.lsp.buf.definition, o "go to definition")
    map("n", "gD", vim.lsp.buf.declaration, o "go to declaration")
    map("n", "<leader>D", vim.lsp.buf.type_definition, o "go to type definition")
    map("n", "<leader>ra", vim.lsp.buf.rename, o "rename")
  end,
})
