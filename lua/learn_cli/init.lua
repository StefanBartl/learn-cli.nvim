---@module 'learn_cli'

local M = {}

M.config = {}

--- Setup Plugin
---@param opts table|nil Configuration options
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", {
    -- Default config
    auto_save_progress = true,
    show_notifications = true,
    working_dir_base = "/tmp/learn-cli",
  }, opts or {})

  -- Initialisiere Module
  require("learn_cli.core.cycle_manager").init()

  -- Registriere Commands (beide Namen unterstützen)
  local commands = require("learn_cli.user_actions.commands")
  if commands.setup then
    commands.setup()
  elseif commands.register then
    commands.register()
  end

  -- Initialisiere State
  require("learn_cli.state").init()
end

--- Startet Dashboard
function M.start()
  require("learn_cli.ui.dashboard").show()
end

--- Startet einen Cycle
---@param cycle_id string
function M.start_cycle(cycle_id)
  local cycle_manager = require("learn_cli.core.cycle_manager")
  local notify = require("learn_cli.utils.notify")

  -- Lade Cycle
  local cycle, err = cycle_manager.load_cycle(cycle_id)
  if not cycle then
    notify.error("Cycle konnte nicht geladen werden: " .. (err or "unknown"))
    return
  end

  -- Speichere aktuellen Cycle
  require("learn_cli.state").set_current_cycle(cycle)

  -- Prüfe ob Info-Einheit angezeigt werden sollte
  local should_show_info, half_cycle = cycle_manager.should_show_info(cycle)
  if not half_cycle then
        vim.notify( "[learn_cli] half_cycle is nil", vim.log.levels.ERROR)
        return
    end

  if should_show_info then
    local info, info_err = cycle_manager.load_info_unit(
      cycle_id,
      cycle.progress.current_iteration,
      half_cycle
    )

    if info then
      require("learn_cli.ui.info_reader").show(info, function()
        M.start_current_exercise(cycle)
      end)
      return
    else
      notify.warn("Info-Einheit nicht gefunden: " .. (info_err or "unknown"))
    end
  end

  -- Starte aktuelles Exercise
  M.start_current_exercise(cycle)
end

--- Startet aktuelles Exercise eines Cycles
---@param cycle table Cycle object
function M.start_current_exercise(cycle)
  local cycle_manager = require("learn_cli.core.cycle_manager")
  local exercise_runner = require("learn_cli.core.exercise_runner")
  local notify = require("learn_cli.utils.notify")

  -- Lade aktuelles Exercise
  local exercise, err = cycle_manager.load_exercise(
    cycle.metadata.cycle_id,
    cycle.progress.current_iteration,
    cycle.progress.current_day,
    cycle.progress.current_exercise
  )

  if not exercise then
    notify.error("Exercise konnte nicht geladen werden: " .. (err or "unknown"))
    return
  end

  -- Starte Exercise
  local state, start_err = exercise_runner.start(
    exercise,
    cycle.metadata.cycle_id,
    cycle.progress.current_iteration,
    cycle.progress.current_day,
    cycle.progress.current_exercise
  )

  if not state then
    notify.error("Exercise konnte nicht gestartet werden: " .. (start_err or "unknown"))
    return
  end

  -- Speichere Exercise State
  require("learn_cli.state").set_current_exercise_state(state)

  -- Setup Keymaps für dieses Exercise
  require("learn_cli.user_actions.keymaps").setup_exercise_keymaps(state)

  notify.info(string.format(
    "Exercise %d/%d gestartet: %s",
    cycle.progress.current_exercise,
    3, -- TODO: dynamisch aus day_data
    exercise.title
  ))
end

--- Fortsetzung des letzten Cycles
function M.continue_cycle()
  local state = require("learn_cli.state")
  local current = state.get_current_cycle()

  if current then
    M.start_cycle(current.metadata.cycle_id)
  else
    require("learn_cli.utils.notify").info("Kein aktiver Cycle gefunden")
    M.start()
  end
end

--- Nächstes Exercise
function M.next_exercise()
  local state = require("learn_cli.state")
  local cycle = state.get_current_cycle()

  if not cycle then
    require("learn_cli.utils.notify").warn("Kein aktiver Cycle")
    return
  end

  local cycle_manager = require("learn_cli.core.cycle_manager")
  local success, msg = cycle_manager.next_exercise(cycle)

  if success then
    -- Speichere Progress
    cycle_manager.save_progress(cycle)

    -- Starte nächstes Exercise
    vim.defer_fn(function()
      M.start_current_exercise(cycle)
    end, 1000)
  else
    require("learn_cli.utils.notify").success(msg or "Cycle abgeschlossen!")

    -- Zeige Cycle Complete Screen
    vim.defer_fn(function()
      require("learn_cli.ui.dashboard").show()
    end, 2000)
  end
end

return M
