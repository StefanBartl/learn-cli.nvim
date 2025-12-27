---@module 'learn_cli'
---@brief Main entry point for learn_cli.nvim
---@description
--- Interactive CLI command learning plugin for Neovim.
--- Provides structured exercises with progress tracking.

local M = {}

-- Dependencies
local config = require('learn_cli.config')

--- Setup learn_cli with user configuration
---@param user_config? LearnCLI.UserConfig
---@return nil
function M.setup(user_config)
  -- Setup config first
  config.setup(user_config)

  -- Initialize state
  local state = require('learn_cli.state')
  local ok, err = state.init()

  if not ok then
    vim.notify(
      string.format([[
Learn CLI initialization warning: %s

To create a cycle template:
  :LearnCLICreateCycle cycle_01

Or configure exercises_path:
  require('learn_cli').setup({
    exercises_path = '/your/path'
  })
]], err or 'unknown error'),
      vim.log.levels.WARN,
      { title = 'Learn CLI' }
    )
  end

  -- Setup commands
  local commands = require('learn_cli.user_actions.commands')
  commands.setup()

  -- Setup keymaps
  local keymaps = require('learn_cli.user_actions.keymaps')
  keymaps.setup(config.keymaps)

  -- Auto-open dashboard
  if config.auto_open_dashboard then
    vim.defer_fn(function()
      require('learn_cli.ui.dashboard').open()
    end, 100)
  end

  vim.notify('Learn CLI loaded', vim.log.levels.INFO, { title = 'Learn CLI' })
end

--- Get current progress (for integrations)
---@return LearnCLI.ProgressInfo
function M.get_progress()
  local state = require('learn_cli.state')
  return state.get_progress()
end

--- Open dashboard programmatically
---@return nil
function M.open_dashboard()
  require('learn_cli.ui.dashboard').open()
end

--- Create cycle template programmatically
---@param cycle_name string
---@param path? string
---@return boolean success
---@return string? error
function M.create_cycle(cycle_name, path)
  local template_gen = require('learn_cli.template_generator')
  return template_gen.create_cycle_template({
    cycle_name = cycle_name,
    path = path,
  })
end

return M
