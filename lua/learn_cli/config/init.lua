---@module 'learn_cli.config'
---@brief Configuration management for learn_cli.nvim
---@description
--- Handles user configuration with defaults and validation.
--- No nested 'options' table - direct field access.

local M = {}

-- Default configuration values
M.exercises_path = vim.fn.stdpath('config') .. '/exercises'
M.auto_open_dashboard = false
M.notify_level = vim.log.levels.INFO

---@type table<string, string>
M.keymaps = {
  next_exercise = '<leader>ln',
  prev_exercise = '<leader>lp',
  toggle_dashboard = '<leader>ld',
}

--- Setup configuration with user options
---@param user_config? LearnCLI.UserConfig
---@return nil
function M.setup(user_config)
  if not user_config then
    return
  end

  -- Type guards
  if type(user_config) ~= 'table' then
    vim.notify(
      'learn_cli.setup() expects a table',
      vim.log.levels.ERROR,
      { title = 'Learn CLI' }
    )
    return
  end

  -- Merge user config
  if user_config.exercises_path then
    if type(user_config.exercises_path) == 'string' then
      M.exercises_path = user_config.exercises_path
    end
  end

  if user_config.auto_open_dashboard ~= nil then
    if type(user_config.auto_open_dashboard) == 'boolean' then
      M.auto_open_dashboard = user_config.auto_open_dashboard
    end
  end

  if user_config.notify_level then
    M.notify_level = user_config.notify_level
  end

  if user_config.keymaps then
    if type(user_config.keymaps) == 'table' then
      M.keymaps = vim.tbl_extend('force', M.keymaps, user_config.keymaps)
    end
  end

  -- Validate exercises path
  if vim.fn.isdirectory(M.exercises_path) == 0 then
    vim.notify(
      string.format('Exercises path does not exist: %s', M.exercises_path),
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
  end
end

--- Get full path to cycles directory
---@return string
function M.get_cycles_path()
  return M.exercises_path .. '/cycles'
end

--- Get full path to specific cycle
---@param cycle_name string
---@return string
function M.get_cycle_path(cycle_name)
  return M.exercises_path .. '/cycles/' .. cycle_name
end

--- Get full path to references directory
---@return string
function M.get_references_path()
  return M.exercises_path .. '/references'
end

return M
