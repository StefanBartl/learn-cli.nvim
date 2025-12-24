---@module 'learn_cli.user_actions.commands'
---@brief Vim command definitions for learn-cli.nvim
---@description
--- Defines all user-facing Ex commands for the plugin.

local M = {}

---Register all commands (alias for setup for backward compatibility)
---@return nil
function M.register()
  M.setup()
end

---Setup all commands
---@return nil
function M.setup()
  -- LearnCli - Zeigt Dashboard
  vim.api.nvim_create_user_command("LearnCli", function(opts)
    if opts.args ~= "" then
      require("learn_cli").start_cycle(opts.args)
    else
      require("learn_cli").start()
    end
  end, {
    nargs = "?",
    complete = function()
      return require("learn_cli.core.cycle_manager").list_cycle_ids()
    end,
    desc = "Start Learn CLI (with optional cycle ID)",
  })

  -- LearnCliContinue - Setzt letzten Cycle fort
  vim.api.nvim_create_user_command("LearnCliContinue", function()
    require("learn_cli").continue_cycle()
  end, {
    desc = "Continue last cycle",
  })

  -- LearnCliSubmit - Reicht Lösung ein
  vim.api.nvim_create_user_command("LearnCliSubmit", function()
    local state = require("learn_cli.state")
    local ex_state = state.get_current_exercise_state()

    if not ex_state then
      require("learn_cli.utils.notify").warn("Kein aktives Exercise")
      return
    end

    local runner = require("learn_cli.core.exercise_runner")
    local result = runner.submit(ex_state)

    if result.success then
      -- Cleanup
      runner.cleanup(ex_state)

      -- Nächstes Exercise nach 2 Sekunden
      vim.defer_fn(function()
        require("learn_cli").next_exercise()
      end, 2000)
    end
  end, {
    desc = "Submit exercise solution",
  })

  -- LearnCliHint - Zeigt Hint
  vim.api.nvim_create_user_command("LearnCliHint", function(opts)
    local state = require("learn_cli.state")
    local ex_state = state.get_current_exercise_state()

    if not ex_state then
      require("learn_cli.utils.notify").warn("Kein aktives Exercise")
      return
    end

    local level = opts.args ~= "" and tonumber(opts.args) or nil
    require("learn_cli.core.exercise_runner").show_hint(ex_state, level)
  end, {
    nargs = "?",
    desc = "Show hint (optional: level)",
  })

  -- LearnCliSolution - Zeigt Lösung
  vim.api.nvim_create_user_command("LearnCliSolution", function()
    local state = require("learn_cli.state")
    local ex_state = state.get_current_exercise_state()

    if not ex_state then
      require("learn_cli.utils.notify").warn("Kein aktives Exercise")
      return
    end

    require("learn_cli.core.exercise_runner").show_solution(ex_state)
  end, {
    desc = "Show solution",
  })

  -- LearnCliQuit - Beendet Exercise
  vim.api.nvim_create_user_command("LearnCliQuit", function()
    local state = require("learn_cli.state")
    local ex_state = state.get_current_exercise_state()

    if not ex_state then
      require("learn_cli.utils.notify").warn("Kein aktives Exercise")
      return
    end

    require("learn_cli.core.exercise_runner").quit(ex_state)
    state.set_current_exercise_state(nil)
  end, {
    desc = "Quit current exercise",
  })

  -- LearnCliProgress - Zeigt Progress
  vim.api.nvim_create_user_command("LearnCliProgress", function()
    local progress = require("learn_cli.state.progress")
    local stats = progress.get_statistics()
    local level, xp = progress.get_level()

    local lines = {
      "=== Learn CLI Progress ===",
      "",
      string.format("Level: %d", level),
      string.format("XP: %d", xp),
      "",
      string.format("Exercises Completed: %d", stats.exercises_completed),
      string.format("Perfect Scores: %d", stats.perfect_scores),
      string.format("Current Streak: %d days", stats.streak),
      string.format("Total Time: %d minutes", math.floor(stats.total_time / 60)),
    }

    require("learn_cli.utils.notify").info(table.concat(lines, "\n"))
  end, {
    desc = "Show progress statistics",
  })

  -- LearnCliReset - Reset Progress (für Testing)
  vim.api.nvim_create_user_command("LearnCliReset", function()
    vim.ui.input({
      prompt = "Reset ALL progress? Type 'yes' to confirm: ",
    }, function(input)
      if input == "yes" then
        require("learn_cli.state.progress").reset()
        require("learn_cli.utils.notify").info("Progress reset")
      end
    end)
  end, {
    desc = "Reset all progress (DANGEROUS!)",
  })
end

return M
