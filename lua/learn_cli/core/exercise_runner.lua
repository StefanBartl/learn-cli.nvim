---@module 'learn_cli.core.exercise_runner'
---@brief Führt Exercises aus und verwaltet deren Lifecycle
---
--- Verantwortlich für:
--- - Setup des Working Directory
--- - Ausführung von Exercises
--- - Hint-System
--- - Lösung anzeigen
--- - Submission und Validation

local M = {}

local validator = require("learn_cli.core.validator")
local scorer = require("learn_cli.core.scorer")
local notify = require("learn_cli.utils.notify")

---@class LearnCLI.ExerciseState
---@field exercise table Exercise data aus YAML
---@field cycle_id string
---@field iteration integer
---@field day integer
---@field exercise_number integer
---@field start_time integer Timestamp
---@field attempts integer Anzahl Versuche
---@field hints_used integer[] Verwendete Hint-Level
---@field solution_viewed boolean Ob Lösung angeschaut wurde
---@field working_dir string Arbeitsverzeichnis
---@field status "running"|"paused"|"completed"|"failed"
---@field original_dir string Original CWD

--- Startet ein Exercise
---@param exercise table Exercise definition
---@param cycle_id string
---@param iteration integer
---@param day integer
---@param exercise_number integer
---@return LearnCLI.ExerciseState|nil, string|nil error
function M.start(exercise, cycle_id, iteration, day, exercise_number)
  -- Working Directory erstellen
  local working_dir = string.format(
    "/tmp/learn-cli/%s/iter%d/day%02d/ex%02d",
    cycle_id,
    iteration,
    day,
    exercise_number
  )

  -- Altes Verzeichnis löschen falls vorhanden
  if vim.fn.isdirectory(working_dir) == 1 then
    vim.fn.delete(working_dir, "rf")
  end

  -- Neues Verzeichnis erstellen
  local ok = pcall(vim.fn.mkdir, working_dir, "p")
  if not ok then
    return nil, "Konnte Working Directory nicht erstellen"
  end

  -- Original CWD speichern
  local original_dir = vim.fn.getcwd()

  -- In Working Directory wechseln
  vim.cmd("cd " .. working_dir)

  -- Setup ausführen (Dateien erstellen, etc.)
  if exercise.setup then
    local setup_ok, setup_err = M.run_setup(exercise.setup, working_dir)
    if not setup_ok then
      vim.cmd("cd " .. original_dir)
      return nil, "Setup fehlgeschlagen: " .. (setup_err or "unknown")
    end
  end

  local state = {
    exercise = exercise,
    cycle_id = cycle_id,
    iteration = iteration,
    day = day,
    exercise_number = exercise_number,
    start_time = os.time(),
    attempts = 0,
    hints_used = {},
    solution_viewed = false,
    working_dir = working_dir,
    status = "running",
    original_dir = original_dir,
  }

  -- UI anzeigen
  require("learn_cli.ui.exercise_view").show(state)

  return state
end

--- Führt Setup aus
---@param setup table Setup configuration
---@param working_dir string
---@return boolean success, string|nil error
function M.run_setup(setup, working_dir)
  -- Dateien erstellen
  if setup.files then
    for _, file_def in ipairs(setup.files) do
      local filepath = working_dir .. "/" .. file_def.name

      -- Unterverzeichnisse erstellen falls nötig
      local dir = vim.fn.fnamemodify(filepath, ":h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
      end

      -- Datei schreiben
      local file = io.open(filepath, "w")
      if not file then
        return false, "Konnte Datei nicht erstellen: " .. file_def.name
      end

      file:write(file_def.content)
      file:close()
    end
  end

  -- Verzeichnisstruktur erstellen
  if setup.structure then
    for _, item in ipairs(setup.structure) do
      local path = working_dir .. "/" .. item

      -- Ist es ein Verzeichnis? (endet mit /)
      if item:sub(-1) == "/" then
        vim.fn.mkdir(path, "p")
      else
        -- Ist eine Datei - Elternverzeichnis erstellen
        local dir = vim.fn.fnamemodify(path, ":h")
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, "p")
        end

        -- Leere Datei erstellen
        local file = io.open(path, "w")
        if file then
          file:close()
        end
      end
    end
  end

  return true
end

--- Benutzer reicht Lösung ein
---@param state LearnCLI.ExerciseState
---@return table result
function M.submit(state)
  state.attempts = state.attempts + 1

  notify.info(string.format("Versuche Lösung zu validieren... (Versuch %d)", state.attempts))

  -- Validierung durchführen
  local validation_result = validator.validate(
    state.exercise.validation,
    state.working_dir
  )

  if not validation_result.success then
    -- Fehlgeschlagen
    notify.error("Lösung ist nicht korrekt!")

    require("learn_cli.ui.exercise_view").show_errors(state, validation_result.errors)

    return {
      success = false,
      errors = validation_result.errors,
      attempts = state.attempts,
    }
  end

  -- Erfolgreich!
  local duration = os.time() - state.start_time
  local score = scorer.calculate_score(state, duration)

  state.status = "completed"

  notify.success(string.format(
    "Korrekt! Punkte: %d/%d (%.0f%%)",
    score.total,
    score.max,
    score.percentage
  ))

  -- UI updaten
  require("learn_cli.ui.exercise_view").show_success(state, score)

  -- Fortschritt speichern
  require("learn_cli.state.progress").save_exercise_result({
    cycle_id = state.cycle_id,
    iteration = state.iteration,
    day = state.day,
    exercise_number = state.exercise_number,
    exercise_id = state.exercise.id,
    duration = duration,
    attempts = state.attempts,
    hints_used = #state.hints_used,
    solution_viewed = state.solution_viewed,
    score = score,
    timestamp = os.time(),
  })

  return {
    success = true,
    score = score,
    duration = duration,
    attempts = state.attempts,
  }
end

--- Zeigt einen Hint an
---@param state LearnCLI.ExerciseState
---@param level integer|nil Hint-Level (default: nächster)
function M.show_hint(state, level)
  if state.solution_viewed then
    notify.warn("Lösung wurde bereits angezeigt - keine Hints mehr verfügbar")
    return
  end

  -- Bestimme Level
  local hint_level = level or (#state.hints_used + 1)

  -- Prüfe ob Hint existiert
  if not state.exercise.hints or not state.exercise.hints[hint_level] then
    notify.error(string.format("Kein Hint auf Level %d verfügbar", hint_level))
    return
  end

  local hint = state.exercise.hints[hint_level]

  -- Prüfe ob Hint bereits verwendet wurde
  if vim.tbl_contains(state.hints_used, hint_level) then
    notify.info("Hint wurde bereits angezeigt:")
  else
    table.insert(state.hints_used, hint_level)
    notify.warn(string.format("Hint %d (-%d Punkte)", hint_level, hint.cost))
  end

  -- Hint anzeigen
  require("learn_cli.ui.exercise_view").show_hint(state, hint)
end

--- Zeigt die Lösung an
---@param state LearnCLI.ExerciseState
function M.show_solution(state)
  if state.solution_viewed then
    notify.info("Lösung wurde bereits angezeigt")
  else
    state.solution_viewed = true

    local penalty = state.exercise.scoring and
                    state.exercise.scoring.hint_penalty and
                    state.exercise.scoring.hint_penalty.viewed_solution or 50

    notify.warn(string.format("Lösung angezeigt (-%d Punkte)", math.abs(penalty)))
  end

  require("learn_cli.ui.exercise_view").show_solution(state)
end

--- Beendet das Exercise (ohne zu speichern)
---@param state LearnCLI.ExerciseState
function M.quit(state)
  -- Zurück zum Original Directory
  vim.cmd("cd " .. state.original_dir)

  -- Cleanup falls konfiguriert
  if state.exercise.setup and state.exercise.setup.cleanup then
    vim.fn.delete(state.working_dir, "rf")
  end

  -- UI schließen
  require("learn_cli.ui.exercise_view").close()

  notify.info("Exercise beendet")
end

--- Cleanup nach Exercise (bei Erfolg)
---@param state LearnCLI.ExerciseState
function M.cleanup(state)
  -- Zurück zum Original Directory
  vim.cmd("cd " .. state.original_dir)

  -- Working Directory löschen falls cleanup aktiviert
  if state.exercise.setup and state.exercise.setup.cleanup then
    vim.fn.delete(state.working_dir, "rf")
  end
end

--- Zeigt Exercise-Informationen
---@param state LearnCLI.ExerciseState
---@return table info
function M.get_info(state)
  local duration = os.time() - state.start_time

  return {
    title = state.exercise.title,
    difficulty = state.exercise.difficulty,
    points_max = state.exercise.points_max,
    duration = duration,
    attempts = state.attempts,
    hints_available = state.exercise.hints and #state.exercise.hints or 0,
    hints_used = #state.hints_used,
    solution_viewed = state.solution_viewed,
    status = state.status,
  }
end

return M
