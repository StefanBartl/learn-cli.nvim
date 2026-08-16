---@module 'learn_cli.core.cycle_manager'
---@brief Verwaltet Cycles, Days und Exercise Navigation
---
--- Verantwortlich für:
--- - Laden von Cycle-Definitionen aus YAML
--- - Navigation zwischen Iterationen/Days/Exercises
--- - Info-Einheiten bereitstellen
---

local M = {}

local yaml_parser = require("learn_cli.utils.yaml_parser")
local is_readable_file = require("lib.nvim.fs.is_readable_file")
local fs_read = require("lib.nvim.fs.read")

--- Initialisiert den Cycle Manager
function M.init()
  -- Erstelle exercises Verzeichnis falls nicht vorhanden
  local exercises_dir = vim.fn.stdpath("config") .. "/exercises"
  require("lib.nvim.fs.mkdirp")(exercises_dir)
end

--- Lädt verfügbare Cycles
---@return string[] cycle_ids Liste aller Cycle IDs
function M.list_cycle_ids()
  local exercises_dir = vim.fn.stdpath("config") .. "/exercises/cycles"

  if vim.fn.isdirectory(exercises_dir) == 0 then
    return {}
  end

  local cycles = {}
  local dirs = vim.fn.readdir(exercises_dir)

  for _, dir in ipairs(dirs) do
    local metadata_path = string.format("%s/%s/metadata.yaml", exercises_dir, dir)
    if is_readable_file(metadata_path) then
      table.insert(cycles, dir)
    end
  end

  return cycles
end

--- Lädt einen Cycle
---@param cycle_id string
---@return LearnCLI.Cycle|nil, string|nil error
function M.load_cycle(cycle_id)
  local exercises_dir = vim.fn.stdpath("config") .. "/exercises/cycles"
  local metadata_path = string.format("%s/%s/metadata.yaml", exercises_dir, cycle_id)

  -- Prüfe ob Datei existiert
  if not is_readable_file(metadata_path) then
    return nil, string.format("Cycle nicht gefunden: %s", cycle_id)
  end

  -- Lade YAML
  local content, read_err = fs_read(metadata_path)
  if not content then
    return nil, string.format("Fehler beim Lesen: %s", read_err)
  end

  local cycle_data, err = yaml_parser.decode(content)
  if err or not cycle_data then
    return nil, string.format("Fehler beim Parsen: %s", err)
  end

  -- Lade Progress
  local progress_module = require("learn_cli.state.progress")
  local progress = progress_module.get_cycle_progress(cycle_id)

  return {
    metadata = cycle_data.metadata,
    data = cycle_data,
    progress = progress,
  }
end

--- Lädt einen spezifischen Tag
---@param cycle_id string
---@param iteration integer
---@param day_number integer
---@return table|nil day_data, string|nil error
function M.load_day(cycle_id, iteration, day_number)
  local exercises_dir = vim.fn.stdpath("config") .. "/exercises/cycles"
  local day_path = string.format(
    "%s/%s/iteration_%d/day_%02d/exercises.yaml",
    exercises_dir,
    cycle_id,
    iteration,
    day_number
  )

  if not is_readable_file(day_path) then
    return nil, string.format("Tag nicht gefunden: day_%02d", day_number)
  end

  local content, read_err = fs_read(day_path)
  if not content then
    return nil, string.format("Fehler beim Lesen: %s", read_err)
  end

  local day_data, err = yaml_parser.decode(content)
  if err then
    return nil, string.format("Fehler beim Parsen: %s", err)
  end

  return day_data
end

--- Lädt ein einzelnes Exercise
---@param cycle_id string
---@param iteration integer
---@param day_number integer
---@param exercise_number integer
---@return table|nil exercise, string|nil error
function M.load_exercise(cycle_id, iteration, day_number, exercise_number)
  local day_data, err = M.load_day(cycle_id, iteration, day_number)
  if not day_data then
    return nil, err
  end

  if not day_data.exercises or #day_data.exercises < exercise_number then
    return nil, string.format("Exercise %d nicht gefunden", exercise_number)
  end

  return day_data.exercises[exercise_number]
end

--- Lädt Info-Einheit für Halbzyklus
---@param cycle_id string
---@param iteration integer
---@param half_cycle "a"|"b"
---@return string|nil content, string|nil error
function M.load_info_unit(cycle_id, iteration, half_cycle)
  local docs_dir = vim.fn.stdpath("config") .. "/docs/cycles"
  local info_path = string.format(
    "%s/%s/iteration_%d/info_%s.md",
    docs_dir,
    cycle_id,
    iteration,
    half_cycle
  )

  if not is_readable_file(info_path) then
    return nil, string.format("Info-Einheit nicht gefunden: info_%s.md", half_cycle)
  end

  local content, read_err = fs_read(info_path)
  if not content then
    return nil, string.format("Fehler beim Lesen: %s", read_err)
  end

  return content
end

--- Prüft ob Info-Einheit angezeigt werden sollte
---@param cycle LearnCLI.Cycle
---@return boolean should_show
---@return "a"|"b"|nil half_cycle
function M.should_show_info(cycle)
  local day = cycle.progress.current_day

  -- Tag 1 = Start Halbzyklus A
  if day == 1 then
    return true, "a"
  end

  -- Tag 4 = Start Halbzyklus B
  if day == 4 then
    return true, "b"
  end

  return false, nil
end

--- Navigiert zum nächsten Exercise
---@param cycle LearnCLI.Cycle
---@return boolean success
---@return string|nil message
function M.next_exercise(cycle)
  local current_day_data, err = M.load_day(
    cycle.metadata.cycle_id,
    cycle.progress.current_iteration,
    cycle.progress.current_day
  )

  if not current_day_data then
    return false, err
  end

  local total_exercises = #current_day_data.exercises

  -- Nächstes Exercise im aktuellen Tag
  if cycle.progress.current_exercise < total_exercises then
    cycle.progress.current_exercise = cycle.progress.current_exercise + 1
    return true, "Nächstes Exercise"
  end

  -- Nächster Tag
  if cycle.progress.current_day < cycle.metadata.days_per_cycle then
    cycle.progress.current_day = cycle.progress.current_day + 1
    cycle.progress.current_exercise = 1
    return true, string.format("Tag %d", cycle.progress.current_day)
  end

  -- Nächste Iteration
  if cycle.progress.current_iteration < cycle.metadata.iterations then
    cycle.progress.current_iteration = cycle.progress.current_iteration + 1
    cycle.progress.current_day = 1
    cycle.progress.current_exercise = 1
    return true, string.format("Iteration %d", cycle.progress.current_iteration)
  end

  -- Cycle abgeschlossen!
  cycle.progress.completed = true
  return false, "Cycle abgeschlossen! 🎉"
end

--- Navigiert zum vorherigen Exercise
---@param cycle LearnCLI.Cycle
---@return boolean success
function M.previous_exercise(cycle)
  -- Vorheriges Exercise im aktuellen Tag
  if cycle.progress.current_exercise > 1 then
    cycle.progress.current_exercise = cycle.progress.current_exercise - 1
    return true
  end

  -- Vorheriger Tag
  if cycle.progress.current_day > 1 then
    cycle.progress.current_day = cycle.progress.current_day - 1

    -- Letztes Exercise des vorherigen Tags
    local day_data = M.load_day(
      cycle.metadata.cycle_id,
      cycle.progress.current_iteration,
      cycle.progress.current_day
    )

    if day_data then
      cycle.progress.current_exercise = #day_data.exercises
      return true
    end
  end

  -- Vorherige Iteration
  if cycle.progress.current_iteration > 1 then
    cycle.progress.current_iteration = cycle.progress.current_iteration - 1
    cycle.progress.current_day = cycle.metadata.days_per_cycle

    local day_data = M.load_day(
      cycle.metadata.cycle_id,
      cycle.progress.current_iteration,
      cycle.progress.current_day
    )

    if day_data then
      cycle.progress.current_exercise = #day_data.exercises
      return true
    end
  end

  return false
end

--- Speichert Cycle Progress
---@param cycle LearnCLI.Cycle
function M.save_progress(cycle)
  local progress_module = require("learn_cli.state.progress")
  progress_module.save_cycle_progress(cycle.metadata.cycle_id, cycle.progress)
end

--- Holt Cycle-Informationen ohne vollständiges Laden
---@param cycle_id string
---@return table|nil info
function M.get_cycle_info(cycle_id)
  local exercises_dir = vim.fn.stdpath("config") .. "/exercises/cycles"
  local metadata_path = string.format("%s/%s/metadata.yaml", exercises_dir, cycle_id)

  if not is_readable_file(metadata_path) then
    return nil
  end

  local content = fs_read(metadata_path)
  if not content then
    return nil
  end

  local cycle_data = yaml_parser.decode(content)
  if not cycle_data then
    return nil
  end

  return {
    id = cycle_id,
    title = cycle_data.metadata.title,
    category = cycle_data.metadata.category,
    iterations = cycle_data.metadata.iterations,
    days = cycle_data.metadata.days_per_cycle,
  }
end

return M
