---@module 'learn_cli.ui.info_reader'
---@brief Zeigt Info-Einheiten an

local M = {}

M.buf = nil
M.win = nil

--- Zeigt Info-Einheit an
---@param content string Markdown content
---@param callback function|nil Callback nach Schließen
function M.show(content, callback)
  -- Erstelle Buffer
  M.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = M.buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = M.buf })

  -- Erstelle Fenster (fullscreen)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  M.win = vim.api.nvim_open_win(M.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Info Unit - Press <q> to continue ",
    title_pos = "center",
  })

  -- Content in Buffer schreiben
  local lines = vim.split(content, "\n")
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })

  -- Keymaps
  M.setup_keymaps(callback)
end

--- Setup Keymaps
---@param callback function|nil
function M.setup_keymaps(callback)
  local opts = {buffer = M.buf, noremap = true, silent = true}

  local function close_and_callback()
    M.close()
    if callback then
      callback()
    end
  end

  vim.keymap.set("n", "q", close_and_callback, opts)
  vim.keymap.set("n", "<CR>", close_and_callback, opts)
  vim.keymap.set("n", "<Esc>", close_and_callback, opts)
end

--- Schließt Info Reader
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
  M.buf = nil
end
