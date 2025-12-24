---@module 'learn_cli.state.progress'
---@brief Speichert und lädt Fortschritt

local M = {}

local storage_file = vim.fn.stdpath("data") .. "/learn-cli-progress.json"

--- Lädt gespeicherten Fortschritt
---@return table
function M.load()
  if vim.fn.filereadable(storage_file) == 0 then
    return M.init_empty()
  end

  local ok, content = pcall(vim.fn.readfile, storage_file)
  if not ok then
    return M.init_empty()
  end

  local data_ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
  if not data_ok then
    return M.init_empty()
  end

  return data
end

--- Speichert Fortschritt
---@param data table
function M.save(data)
  local ok, json = pcall(vim.json.encode, data)
  if not ok then
    vim.notify("Fehler beim Speichern des Fortschritts", vim.log.levels.ERROR)
    return
  end

  vim.fn.writefile(vim.split(json, "\n"), storage_file)
end

--- Initialisiert leeren Fortschritt
---@return table
function M.init_empty()
  return {
    cycles = {},
    exercises = {},
    achievements = {},
    statistics = {
      total_time = 0,
      exercises_completed = 0,
      perfect_scores = 0,
      streak = 0,
      last_activity = nil,
    },
    level = 1,
    xp = 0,
  }
end

--- Holt Cycle-Fortschritt
---@param cycle_id string
---@return table progress
function M.get_cycle_progress(cycle_id)
  local data = M.load()
  return data.cycles[cycle_id] or {
    current_iteration = 1,
    current_day = 1,
    current_exercise = 1,
    completed = false,
  }
end

--- Speichert Cycle-Fortschritt
---@param cycle_id string
---@param progress table
function M.save_cycle_progress(cycle_id, progress)
  local data = M.load()
  data.cycles[cycle_id] = progress
  M.save(data)
end

--- Speichert Exercise-Ergebnis
---@param result table
function M.save_exercise_result(result)
  local data = M.load()

  -- Exercise hinzufügen
  table.insert(data.exercises, result)

  -- Statistiken updaten
  data.statistics.exercises_completed = data.statistics.exercises_completed + 1
  data.statistics.total_time = data.statistics.total_time + result.duration

  if result.score.percentage >= 100 then
    data.statistics.perfect_scores = data.statistics.perfect_scores + 1
  end

  -- Streak updaten
  local today = os.date("%Y-%m-%d")
  if data.statistics.last_activity ~= today then
    local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
    if data.statistics.last_activity == yesterday then
      data.statistics.streak = data.statistics.streak + 1
    else
      data.statistics.streak = 1
    end
    data.statistics.last_activity = today
  end

  -- XP hinzufügen
  data.xp = data.xp + 25

  -- Level-Up prüfen
  local new_level = math.floor(data.xp / 250) + 1
  if new_level > data.level then
    data.level = new_level
    require("learn_cli.utils.notify").success(
      string.format("Level Up! Du bist jetzt Level %d 🎉", new_level)
    )
  end

  M.save(data)
end

--- Holt aktuelle Statistiken
---@return table statistics
function M.get_statistics()
  local data = M.load()
  return data.statistics
end

--- Holt aktuellen Level und XP
---@return integer level, integer xp
function M.get_level()
  local data = M.load()
  return data.level, data.xp
end

--- Holt alle Exercise-Ergebnisse
---@return table[] exercises
function M.get_all_exercises()
  local data = M.load()
  return data.exercises
end

--- Holt Exercise-Ergebnisse für einen Cycle
---@param cycle_id string
---@return table[] exercises
function M.get_cycle_exercises(cycle_id)
  local data = M.load()
  local filtered = {}

  for _, ex in ipairs(data.exercises) do
    if ex.cycle_id == cycle_id then
      table.insert(filtered, ex)
    end
  end

  return filtered
end

--- Reset Progress (für Testing)
function M.reset()
  M.save(M.init_empty())
  vim.notify("Progress wurde zurückgesetzt", vim.log.levels.INFO)
end

return M
