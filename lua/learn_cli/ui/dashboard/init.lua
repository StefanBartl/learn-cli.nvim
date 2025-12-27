---@module 'learn_cli.ui.dashboard'
---@brief Main dashboard UI for learn_cli.nvim

local M = {}

-- Forward declarations
local validate_handles
local generate_content
local create_buffer
local create_window

-- State
---@type integer?
local buf = nil
---@type integer?
local win = nil
---@type boolean
local is_open = false

--- Validate and clean up invalid handles
---@return nil
validate_handles = function()
  if buf and not vim.api.nvim_buf_is_valid(buf) then
    buf = nil
  end

  if win and not vim.api.nvim_win_is_valid(win) then
    win = nil
  end

  if win and buf then
    local ok, win_buf = pcall(vim.api.nvim_win_get_buf, win)
    if not ok or win_buf ~= buf then
      win = nil
    end
  end
end

--- Generate dashboard content
---@return string[]
generate_content = function()
  local state = require('learn_cli.state')
  local info = state.get_cycle_info()
  local progress = state.get_progress()
  local exercise = state.get_current_exercise()

  local lines = {
    '╔══════════════════════════════════════════════════════════╗',
    '║                    LEARN CLI DASHBOARD                   ║',
    '╚══════════════════════════════════════════════════════════╝',
    '',
    '┌─ Cycle Information ─────────────────────────────────────┐',
    string.format('│ Name: %-49s │', info.name),
    string.format('│ Description: %-43s │', info.description),
    string.format('│ Difficulty: %-44s │', info.difficulty),
    '└─────────────────────────────────────────────────────────┘',
    '',
    '┌─ Progress ──────────────────────────────────────────────┐',
  }

  -- Progress bar
  local day_pct = progress.total_days > 0
    and (progress.current_day / progress.total_days)
    or 0
  local bar_width = 40
  local filled = math.floor(day_pct * bar_width)
  local bar = string.rep('━', filled) .. string.rep('─', bar_width - filled)

  table.insert(lines, string.format('│ Day: %d/%d %s │',
    progress.current_day,
    progress.total_days,
    bar
  ))
  table.insert(lines, string.format('│ Iteration: %d/%d %-41s │',
    progress.current_iteration,
    progress.total_iterations,
    ''
  ))
  table.insert(lines, string.format('│ Exercise: %d/%d %-42s │',
    progress.current_exercise,
    progress.total_exercises,
    ''
  ))
  table.insert(lines, '└─────────────────────────────────────────────────────────┘')
  table.insert(lines, '')

  -- Current exercise
  if exercise then
    table.insert(lines, '┌─ Current Exercise ──────────────────────────────────────┐')
    table.insert(lines, string.format('│ Title: %-49s │', exercise.title or 'Untitled'))
    table.insert(lines, string.format('│ Command: %-47s │', exercise.command or 'N/A'))
    table.insert(lines, string.format('│ Difficulty: %-44s │', exercise.difficulty or 'N/A'))
    table.insert(lines, '│                                                         │')
    table.insert(lines, '│ Description:                                            │')

    local desc = exercise.description or 'No description'
    for i = 1, #desc, 50 do
      local chunk = desc:sub(i, i + 49)
      table.insert(lines, string.format('│   %-52s │', chunk))
    end

    table.insert(lines, '└─────────────────────────────────────────────────────────┘')
  else
    table.insert(lines, '┌─ Current Exercise ──────────────────────────────────────┐')
    table.insert(lines, '│ No exercise loaded                                      │')
    table.insert(lines, '│                                                         │')
    table.insert(lines, '│ Create a cycle: :LearnCLICreateCycle cycle_01           │')
    table.insert(lines, '└─────────────────────────────────────────────────────────┘')
  end

  table.insert(lines, '')
  table.insert(lines, '┌─ Keybindings ───────────────────────────────────────────┐')
  table.insert(lines, '│ q         - Close dashboard                             │')
  table.insert(lines, '│ n         - Next exercise                               │')
  table.insert(lines, '│ p         - Previous exercise                           │')
  table.insert(lines, '│ <leader>ld - Toggle dashboard                            │')
  table.insert(lines, '│ :LearnCLIInfo    - Show cycle info                      │')
  table.insert(lines, '│ :LearnCLIReset   - Reset progress                       │')
  table.insert(lines, '└─────────────────────────────────────────────────────────┘')

  return lines
end

--- Create dashboard buffer
---@return integer
create_buffer = function()
  local b = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = b })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = b })
  vim.api.nvim_set_option_value('swapfile', false, { buf = b })
  vim.api.nvim_set_option_value('filetype', 'learn_cli_dashboard', { buf = b })
  vim.api.nvim_set_option_value('modifiable', false, { buf = b })

  -- Buffer-local keymaps
  local opts = { noremap = true, silent = true, buffer = b }
  vim.keymap.set('n', 'q', function() M.close() end, opts)
  vim.keymap.set('n', 'n', function()
    vim.cmd('LearnCLINext')
  end, opts)
  vim.keymap.set('n', 'p', function()
    vim.cmd('LearnCLIPrev')
  end, opts)

  return b
end

--- Create dashboard window
---@param b integer Buffer handle
---@return integer
create_window = function(b)
  local width = 60
  local height = 30

  local w = vim.api.nvim_open_win(b, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_set_option_value('cursorline', true, { win = w })
  vim.api.nvim_set_option_value('wrap', false, { win = w })

  return w
end

--- Refresh dashboard content
---@return nil
function M.refresh()
  validate_handles()

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local lines = generate_content()

  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
end

--- Open dashboard
---@return nil
function M.open()
  validate_handles()

  if is_open and win and vim.api.nvim_win_is_valid(win) then
    return
  end

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = create_buffer()
  end

  win = create_window(buf)
  is_open = true

  M.refresh()
end

--- Close dashboard
---@return nil
function M.close()
  validate_handles()

  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end

  win = nil
  is_open = false
end

--- Toggle dashboard
---@return nil
function M.toggle()
  validate_handles()

  if is_open then
    M.close()
  else
    M.open()
  end
end

return M
