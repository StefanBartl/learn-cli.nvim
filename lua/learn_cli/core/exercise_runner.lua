---@module 'learn_cli.core.exercise_runner'
---@brief Exercise execution and validation logic

local M = {}

-- Dependencies
local state = require('learn_cli.state')

---@type integer?
M.buf = nil

--- Normalize hint to table structure
---@param hint_data string|LearnCLI.HintData
---@param level? integer
---@return LearnCLI.HintData
local function normalize_hint(hint_data, level)
  -- Type guard
  if type(hint_data) == 'string' then
    return {
      text = hint_data,
      level = level or 1,
      cost = 10,
    }
  end

  if type(hint_data) == 'table' then
    return {
      text = hint_data.text or '',
      level = hint_data.level or level or 1,
      cost = hint_data.cost or 10,
    }
  end

  -- Fallback
  return {
    text = 'No hint available',
    level = 1,
    cost = 0,
  }
end

--- Show hint with proper structure
---@param exercise_state table
---@param hint_data string|LearnCLI.HintData
---@return nil
function M.show_hint(exercise_state, hint_data)
  if type(exercise_state) ~= 'table' then
    vim.notify(
      'Invalid exercise state',
      vim.log.levels.ERROR,
      { title = 'Learn CLI' }
    )
    return
  end

  -- Normalize hint to table structure
  local hint = normalize_hint(hint_data, exercise_state.hint_level or 1)

  -- Validate buffer
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    vim.notify(
      'Exercise view not initialized',
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
    return
  end

  -- Build hint display lines
  local lines = {
    '',
    '  ' .. string.rep('─', 50),
    string.format('  💡 Hint Level %d (Cost: %d points)',
      hint.level, hint.cost),
    '  ' .. string.rep('─', 50),
    '',
  }

  -- Split hint text by newlines
  for line in hint.text:gmatch('[^\n]+') do
    table.insert(lines, '  ' .. line)
  end
  table.insert(lines, '')

  -- Write to buffer
  local ok = pcall(function()
    vim.api.nvim_set_option_value('modifiable', true, { buf = M.buf })
    vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
    vim.api.nvim_set_option_value('modifiable', false, { buf = M.buf })
  end)

  if not ok then
    vim.notify(
      'Failed to display hint',
      vim.log.levels.ERROR,
      { title = 'Learn CLI' }
    )
  end
end

--- Request hint for current exercise
---@param exercise_state table
---@return boolean success
function M.request_hint(exercise_state)
  if type(exercise_state) ~= 'table' then
    return false
  end

  local current_exercise = state.get_current_exercise()
  if not current_exercise then
    vim.notify(
      'No exercise loaded',
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
    return false
  end

  -- Get hints from exercise
  local hints = current_exercise.hints
  if not hints or type(hints) ~= 'table' or #hints == 0 then
    vim.notify(
      'No hints available for this exercise',
      vim.log.levels.INFO,
      { title = 'Learn CLI' }
    )
    return false
  end

  -- Determine next hint level
  local hint_level = exercise_state.hint_level or 0
  hint_level = hint_level + 1

  if hint_level > #hints then
    vim.notify(
      'All hints already shown',
      vim.log.levels.INFO,
      { title = 'Learn CLI' }
    )
    return false
  end

  -- Get hint (might be string or table)
  local hint_data = hints[hint_level]

  -- Show hint with normalized structure
  M.show_hint(exercise_state, hint_data)

  -- Update state
  exercise_state.hint_level = hint_level

  return true
end

--- Validate exercise solution
---@param exercise_state table
---@param user_input string
---@return boolean is_correct
---@return string? message
function M.validate_solution(exercise_state, user_input)
  if type(exercise_state) ~= 'table' then
    return false, 'Invalid exercise state'
  end
  if type(user_input) ~= 'string' or user_input == '' then
    return false, 'No input provided'
  end

  local current_exercise = state.get_current_exercise()
  if not current_exercise then
    return false, 'No exercise loaded'
  end

  local solution = current_exercise.solution
  if type(solution) ~= 'string' then
    return false, 'No solution defined'
  end

  -- Trim whitespace for comparison
  local user_trimmed = vim.trim(user_input)
  local solution_trimmed = vim.trim(solution)

  if user_trimmed == solution_trimmed then
    return true, 'Correct! Well done!'
  end

  return false, 'Not quite right. Try again or request a hint.'
end

--- Show solution for current exercise
---@param exercise_state table
---@return nil
function M.show_solution(exercise_state)
  if type(exercise_state) ~= 'table' then
    return
  end

  local current_exercise = state.get_current_exercise()
  if not current_exercise then
    vim.notify(
      'No exercise loaded',
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
    return
  end

  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    vim.notify(
      'Exercise view not initialized',
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
    return
  end

  local lines = {
    '',
    '  ' .. string.rep('═', 50),
    '  📖 Solution:',
    '  ' .. string.rep('═', 50),
    '',
    '  ' .. (current_exercise.solution or 'No solution available'),
    '',
  }

  local ok = pcall(function()
    vim.api.nvim_set_option_value('modifiable', true, { buf = M.buf })
    vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
    vim.api.nvim_set_option_value('modifiable', false, { buf = M.buf })
  end)

  if not ok then
    vim.notify(
      'Failed to display solution',
      vim.log.levels.ERROR,
      { title = 'Learn CLI' }
    )
  end

  -- Mark exercise as completed with penalty
  exercise_state.solution_shown = true
end

return M
