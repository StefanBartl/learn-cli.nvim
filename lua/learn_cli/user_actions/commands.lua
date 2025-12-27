---@module 'learn_cli.user_actions.commands'
---@brief User commands for learn_cli.nvim

local M = {}

-- Dependencies
local config = require('learn_cli.config')

--- Setup all user commands
---@return nil
function M.setup()
  -- Toggle dashboard
  vim.api.nvim_create_user_command('LearnCLIDashboard', function()
    require('learn_cli.ui.dashboard').toggle()
  end, {
    desc = 'Toggle Learn CLI dashboard'
  })

  -- Next exercise
  vim.api.nvim_create_user_command('LearnCLINext', function()
    local state = require('learn_cli.state')
    local ok = state.next_exercise()

    if ok then
      local progress = state.get_progress()
      vim.notify(
        string.format('Exercise %d/%d', progress.current_exercise, progress.total_exercises),
        config.notify_level,
        { title = 'Learn CLI' }
      )

      -- Refresh dashboard if open
      local dashboard = require('learn_cli.ui.dashboard')
      dashboard.refresh()
    else
      vim.notify('Last exercise of the day', vim.log.levels.INFO, { title = 'Learn CLI' })
    end
  end, {
    desc = 'Move to next exercise'
  })

  -- Previous exercise
  vim.api.nvim_create_user_command('LearnCLIPrev', function()
    local state = require('learn_cli.state')
    local ok = state.prev_exercise()

    if ok then
      local progress = state.get_progress()
      vim.notify(
        string.format('Exercise %d/%d', progress.current_exercise, progress.total_exercises),
        config.notify_level,
        { title = 'Learn CLI' }
      )

      local dashboard = require('learn_cli.ui.dashboard')
      dashboard.refresh()
    else
      vim.notify('First exercise of the day', vim.log.levels.INFO, { title = 'Learn CLI' })
    end
  end, {
    desc = 'Move to previous exercise'
  })

  -- Show cycle info
  vim.api.nvim_create_user_command('LearnCLIInfo', function()
    local state = require('learn_cli.state')
    local info = state.get_cycle_info()
    local progress = state.get_progress()

    local msg = string.format([[
Cycle: %s
Description: %s
Progress: Day %d/%d
Iteration: %d/%d
Current Exercise: %d/%d
]],
      info.name,
      info.description,
      progress.current_day,
      progress.total_days,
      progress.current_iteration,
      progress.total_iterations,
      progress.current_exercise,
      progress.total_exercises
    )

    vim.notify(msg, vim.log.levels.INFO, { title = 'Learn CLI Info' })
  end, {
    desc = 'Show current cycle information'
  })

  -- Reset progress
  vim.api.nvim_create_user_command('LearnCLIReset', function()
    vim.ui.input({
      prompt = 'Reset all progress? (yes/no): ',
    }, function(input)
      if input and input:lower() == 'yes' then
        local state = require('learn_cli.state')
        state.reset_progress()
        vim.notify('Progress reset', vim.log.levels.INFO, { title = 'Learn CLI' })

        local dashboard = require('learn_cli.ui.dashboard')
        dashboard.refresh()
      end
    end)
  end, {
    desc = 'Reset all progress (requires confirmation)'
  })

  -- Create cycle template
  vim.api.nvim_create_user_command('LearnCLICreateCycle', function(cmd_opts)
    local args = vim.split(cmd_opts.args or '', '%s+')
    local cycle_name = args[1]
    local custom_path = args[2]

    if not cycle_name or cycle_name == '' then
      vim.notify(
        'Usage: :LearnCLICreateCycle <cycle_name> [path]',
        vim.log.levels.ERROR,
        { title = 'Learn CLI' }
      )
      return
    end

    vim.notify(
      string.format('Creating cycle template: %s...', cycle_name),
      vim.log.levels.INFO,
      { title = 'Learn CLI' }
    )

    local template_gen = require('learn_cli.template_generator')
    local ok, err = template_gen.create_cycle_template({
      cycle_name = cycle_name,
      path = custom_path,
      iterations = 3,
      days_per_iteration = 7,
    })

    if ok then
      local path = custom_path or config.exercises_path
      local cycle_path = path .. '/cycles/' .. cycle_name
      vim.notify(
        string.format('Cycle template created: %s', cycle_path),
        vim.log.levels.INFO,
        { title = 'Learn CLI' }
      )
    else
      vim.notify(
        string.format('Failed to create cycle: %s', err or 'unknown error'),
        vim.log.levels.ERROR,
        { title = 'Learn CLI' }
      )
    end
  end, {
    nargs = '*',
    desc = 'Create new cycle template with structure',
    complete = function()
      return { 'cycle_01', 'cycle_02', 'cycle_03' }
    end
  })
end

return M
