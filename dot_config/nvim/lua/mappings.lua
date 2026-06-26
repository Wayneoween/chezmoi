---@diagnostic disable: undefined-global

require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", {
  desc = "Search and replace all of the selected words.",
})

map("i", "<C-l>", function()
  vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
end, {
  desc = "Copilot Accept",
})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
