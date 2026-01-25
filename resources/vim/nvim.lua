vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")

vim.keymap.set("i", ";", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  if vim.tbl_contains({ "()", "[]", "{}" }, line:sub(col, col + 1)) then
    return "<Esc>la;<Esc>hi"
  else
    return ";"
  end
end, { expr = true, noremap = true })

vim.lsp.buf.empty_rename = function()
  vim.ui.input({ prompt = "New Name: " }, function(name)
    vim.lsp.buf.rename(name)
  end)
end
