---@module 'learn_cli.ui.info_reader'
---@brief Zeigt Info-Einheiten an

local M = {}

M.buf = nil
M.win = nil

--- Zeigt Info-Einheit an
---@param content string Markdown content
---@param callback function|nil Callback nach Schließen
function M.show(content, callback)
  local surf = require("lib.nvim.ui.kit").viewer({
    lines = vim.split(content, "\n"),
    title = " Info Unit - Press <q> to continue ",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
    filetype = "markdown",
  })
  if not surf then
    return
  end

  M.buf = surf.bufnr
  M.win = surf.winid

  -- viewer's own q/<Esc> already close it; <CR> is this reader's extra
  -- "continue" key on top of that.
  vim.keymap.set("n", "<CR>", function()
    M.close()
  end, { buffer = surf.bufnr, noremap = true, silent = true })

  if callback then
    surf:on_close(callback)
  end
end

--- Schließt Info Reader
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
  M.buf = nil
end
