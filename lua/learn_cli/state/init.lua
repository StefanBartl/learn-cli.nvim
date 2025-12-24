---@module 'learn_cli.state'
---@brief Verwaltet Plugin State
---@description
--- Zentraler State Manager für das Plugin.
--- Verwaltet aktuellen Cycle, Exercise State und Session-Daten.

---@class StateManager
local M = {}

---@type table|nil Current cycle data
M.current_cycle = nil

---@type table|nil Current exercise state
M.current_exercise_state = nil

---@type LearnCLI.State|nil Complete state snapshot
M._state_snapshot = nil

--- Initialisiert den State Manager
---@return nil
function M.init()
  -- State-Snapshot initialisieren falls noch nicht vorhanden
  if not M._state_snapshot then
    M._state_snapshot = {
      exercises = {},
      cycles = {},
      progress = {},
      cycle_progress = {},
      current_exercise_id = nil,
      current_cycle_id = nil,
      session_start = nil,
      total_practice_time = 0,
    }
  end
end

--- Setzt aktuellen Cycle
---@param cycle table|nil Cycle object
---@return nil
function M.set_current_cycle(cycle)
  M.current_cycle = cycle

  if cycle and cycle.metadata then
    M._state_snapshot = M._state_snapshot or {}
    M._state_snapshot.current_cycle_id = cycle.metadata.cycle_id
  end
end

--- Holt aktuellen Cycle
---@return table|nil cycle Current cycle or nil
function M.get_current_cycle()
  return M.current_cycle
end

--- Setzt aktuellen Exercise State
---@param state table|nil Exercise state object
---@return nil
function M.set_current_exercise_state(state)
  M.current_exercise_state = state

  if state and state.exercise then
    M._state_snapshot = M._state_snapshot or {}
    M._state_snapshot.current_exercise_id = state.exercise.id
  end
end

--- Holt aktuellen Exercise State
---@return table|nil state Current exercise state or nil
function M.get_current_exercise_state()
  return M.current_exercise_state
end

--- Erstellt Snapshot des aktuellen States
---@return LearnCLI.State|nil snapshot State snapshot or nil if not initialized
function M.get_snapshot()
  if not M._state_snapshot then
    M.init()
  end

  -- Update snapshot mit aktuellen Daten
  if M._state_snapshot then
    M._state_snapshot.current_cycle_id = M.current_cycle and
                                         M.current_cycle.metadata and
                                         M.current_cycle.metadata.cycle_id or nil

    M._state_snapshot.current_exercise_id = M.current_exercise_state and
                                            M.current_exercise_state.exercise and
                                            M.current_exercise_state.exercise.id or nil
  end

  return M._state_snapshot
end

--- Stellt State aus Snapshot wieder her
---@param snapshot LearnCLI.State State snapshot
---@return LearnCLI.OperationResult result Operation result
function M.restore_snapshot(snapshot)
  local ok, result = pcall(function()
    if type(snapshot) ~= "table" then
      return {
        ok = false,
        error = "Invalid snapshot: expected table, got " .. type(snapshot),
        data = nil
      }
    end

    -- Validiere Snapshot-Struktur
    local required_fields = {
      "exercises",
      "cycles",
      "progress",
      "cycle_progress",
      "total_practice_time"
    }

    for _, field in ipairs(required_fields) do
      if snapshot[field] == nil then
        return {
          ok = false,
          error = "Invalid snapshot: missing field '" .. field .. "'",
          data = nil
        }
      end
    end

    -- Restore snapshot
    M._state_snapshot = vim.deepcopy(snapshot)

    return {
      ok = true,
      error = nil,
      data = snapshot
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Failed to restore snapshot: " .. tostring(result),
      data = nil
    }
  end

  return result
end

--- Löscht aktuellen State (für Testing/Reset)
---@return nil
function M.clear()
  M.current_cycle = nil
  M.current_exercise_state = nil

  -- Cleanup Keymaps
  local keymaps = require("learn_cli.user_actions.keymaps")
  if keymaps.cleanup_exercise_keymaps then
    keymaps.cleanup_exercise_keymaps()
  end
end

--- Setzt Session-Start-Zeit
---@param timestamp number|nil Unix timestamp (nil = now)
---@return nil
function M.set_session_start(timestamp)
  M._state_snapshot = M._state_snapshot or {}
  M._state_snapshot.session_start = timestamp or os.time()
end

--- Holt Session-Start-Zeit
---@return number|nil timestamp Session start time or nil
function M.get_session_start()
  return M._state_snapshot and M._state_snapshot.session_start or nil
end

--- Addiert Zeit zur Gesamt-Practice-Zeit
---@param seconds number Seconds to add
---@return nil
function M.add_practice_time(seconds)
  M._state_snapshot = M._state_snapshot or {}
  M._state_snapshot.total_practice_time = (M._state_snapshot.total_practice_time or 0) + seconds
end

--- Holt Gesamt-Practice-Zeit
---@return number seconds Total practice time in seconds
function M.get_total_practice_time()
  return M._state_snapshot and M._state_snapshot.total_practice_time or 0
end

return M
