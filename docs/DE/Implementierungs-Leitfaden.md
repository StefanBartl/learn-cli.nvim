--[[
================================================================================
Implementierungsleitfaden: learn-cli.nvim Exercise/Cycle System
================================================================================

Dieser Guide zeigt die Implementierung des Cycle/Exercise-Systems mit:
- Cycle Management
- Exercise Runner
- Validation System
- Progress Tracking
- Gamification Features

Dateistruktur:
lua/learn_cli/
├── core/
│   ├── cycle_manager.lua      -- Cycles laden und verwalten
│   ├── exercise_runner.lua    -- Exercises ausführen
│   ├── validator.lua          -- Lösungen validieren
│   └── scorer.lua             -- Punkteberechnung
├── state/
│   ├── progress.lua           -- Fortschritt speichern
│   ├── statistics.lua         -- Statistiken berechnen
│   └── achievements.lua       -- Achievements verwalten
├── ui/
│   ├── dashboard.lua          -- Haupt-UI
│   ├── exercise_view.lua      -- Exercise-Ansicht
│   ├── info_reader.lua        -- Info-Einheiten anzeigen
│   └── results.lua            -- Ergebnisse anzeigen
└── gamification/
    ├── achievements.lua       -- Achievement System
    ├── levels.lua             -- Level/XP System
    └── streaks.lua            -- Streak Tracking

================================================================================
]]

---@module 'learn_cli.core.cycle_manager'
---@brief Verwaltet Cycles und deren Fortschritt
---
--- Verantwortlich für:
--- - Laden von Cycle-Definitionen (YAML/JSON)
--- - Navigation zwischen Days/Exercises
--- - Iteration Management
--- - Info-Einheiten laden
---

local M = {}

local yaml = require("learn_cli.utils.yaml")
local notify = require("learn_cli.utils.notify")
local progress = require("learn_cli.state.progress")

---@class CycleMetadata
---@field cycle_id string
---@field title string
---@field version string
---@field iterations integer
---@field days_per_cycle integer

---@class Exercise
---@field id string
---@field title string
---@field difficulty integer 1-10
---@field points_max integer
---@field task table
---@field solution table
---@field validation table
---@field hints table[]

---@class Day
---@field day_id string
---@field program_id string
---@field exercises Exercise[]
---@field setup table

---@class Cycle
---@field metadata CycleMetadata
---@field iterations table[]
---@field current_iteration integer
---@field current_day integer
---@field current_exercise integer

--- Lädt einen Cycle aus Datei
---@param cycle_id string
---@return Cycle|nil, string|nil error
function M.load_cycle(cycle_id)
  local cycle_path = string.format("exercises/cycles/%s/metadata.yaml", cycle_id)

  local ok, content = pcall(vim.fn.readfile, cycle_path)
  if not ok then
    return nil, string.format("Cycle nicht gefunden: %s", cycle_id)
  end

  local cycle_data, err = yaml.decode(table.concat(content, "\n"))
  if err then
    return nil, string.format("Fehler beim Parsen: %s", err)
  end

  -- Aktuellen Fortschritt laden
  local prog = progress.get_cycle_progress(cycle_id)

  return {
    metadata = cycle_data.metadata,
    iterations = cycle_data,
    current_iteration = prog.current_iteration or 1,
    current_day = prog.current_day or 1,
    current_exercise = prog.current_exercise or 1,
  }
end

--- Lädt einen spezifischen Tag
---@param cycle_id string
---@param iteration integer
---@param day_number integer
---@return Day|nil, string|nil error
function M.load_day(cycle_id, iteration, day_number)
  local day_path = string.format(
    "exercises/cycles/%s/iteration_%d/day_%02d/exercises.yaml",
    cycle_id,
    iteration,
    day_number
  )

  local ok, content = pcall(vim.fn.readfile, day_path)
  if not ok then
    return nil, string.format("Tag nicht gefunden: %s", day_path)
  end

  local day_data, err = yaml.decode(table.concat(content, "\n"))
  if err then
    return nil, string.format("Fehler beim Parsen: %s", err)
  end

  return day_data
end

--- Lädt Info-Einheit
---@param cycle_id string
---@param iteration integer
---@param half_cycle "a"|"b"
---@return string|nil, string|nil error
function M.load_info_unit(cycle_id, iteration, half_cycle)
  local info_path = string.format(
    "docs/cycles/%s/iteration_%d/info_%s.md",
    cycle_id,
    iteration,
    half_cycle
  )

  local ok, lines = pcall(vim.fn.readfile, info_path)
  if not ok then
    return nil, string.format("Info-Einheit nicht gefunden: %s", info_path)
  end

  return table.concat(lines, "\n")
end

--- Navigiert zum nächsten Exercise
---@param cycle Cycle
---@return boolean success, string|nil error
function M.next_exercise(cycle)
  local day = M.load_day(
    cycle.metadata.cycle_id,
    cycle.current_iteration,
    cycle.current_day
  )

  if not day then
    return false, "Tag konnte nicht geladen werden"
  end

  -- Nächstes Exercise im aktuellen Tag
  if cycle.current_exercise < #day.exercises then
    cycle.current_exercise = cycle.current_exercise + 1
    progress.save_cycle_progress(cycle)
    return true
  end

  -- Nächster Tag
  if cycle.current_day < cycle.metadata.days_per_cycle then
    cycle.current_day = cycle.current_day + 1
    cycle.current_exercise = 1
    progress.save_cycle_progress(cycle)
    return true
  end

  -- Nächste Iteration
  if cycle.current_iteration < cycle.metadata.iterations then
    cycle.current_iteration = cycle.current_iteration + 1
    cycle.current_day = 1
    cycle.current_exercise = 1
    progress.save_cycle_progress(cycle)
    return true
  end

  -- Cycle abgeschlossen
  return false, "Cycle abgeschlossen!"
end

return M

-- ============================================================================
-- EXERCISE RUNNER
-- ============================================================================

---@module 'learn_cli.core.exercise_runner'
---@brief Führt Exercises aus und verwaltet deren Lifecycle

local ExerciseRunner = {}

local validator = require("learn_cli.core.validator")
local scorer = require("learn_cli.core.scorer")
local ui = require("learn_cli.ui.exercise_view")

---@class ExerciseState
---@field exercise Exercise
---@field start_time integer timestamp
---@field attempts integer
---@field hints_used integer[]
---@field solution_viewed boolean
---@field working_dir string
---@field status "running"|"paused"|"completed"|"failed"

--- Startet ein Exercise
---@param exercise Exercise
---@param working_dir string
---@return ExerciseState
function ExerciseRunner.start(exercise, working_dir)
  -- Setup arbeitsverzeichnis
  vim.fn.mkdir(working_dir, "p")
  vim.fn.chdir(working_dir)

  -- Setup files falls vorhanden
  if exercise.setup and exercise.setup.files then
    for _, file in ipairs(exercise.setup.files) do
      local f = io.open(file.name, "w")
      if f then
        f:write(file.content)
        f:close()
      end
    end
  end

  local state = {
    exercise = exercise,
    start_time = os.time(),
    attempts = 0,
    hints_used = {},
    solution_viewed = false,
    working_dir = working_dir,
    status = "running",
  }

  -- UI anzeigen
  ui.show_exercise(state)

  return state
end

--- Benutzer möchte Lösung einreichen
---@param state ExerciseState
---@return table result
function ExerciseRunner.submit(state)
  state.attempts = state.attempts + 1

  -- Validierung
  local validation_result = validator.validate(state.exercise.validation, state.working_dir)

  if not validation_result.success then
    -- Fehlgeschlagen
    ui.show_feedback(state, validation_result.errors, false)
    return {
      success = false,
      errors = validation_result.errors,
    }
  end

  -- Erfolgreich - Punkte berechnen
  local duration = os.time() - state.start_time
  local score = scorer.calculate_score(state, duration)

  state.status = "completed"

  -- UI updaten
  ui.show_feedback(state, nil, true, score)

  -- Fortschritt speichern
  progress.save_exercise_result({
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
  }
end

--- Hint anzeigen
---@param state ExerciseState
---@param level integer
function ExerciseRunner.show_hint(state, level)
  if state.solution_viewed then
    notify.warn("Lösung wurde bereits angezeigt")
    return
  end

  local hint = state.exercise.hints[level]
  if not hint then
    notify.error("Kein Hint auf diesem Level verfügbar")
    return
  end

  table.insert(state.hints_used, level)
  ui.show_hint(hint)
end

--- Lösung anzeigen
---@param state ExerciseState
function ExerciseRunner.show_solution(state)
  state.solution_viewed = true
  ui.show_solution(state.exercise.solution)
end

return ExerciseRunner

-- ============================================================================
-- VALIDATOR
-- ============================================================================

---@module 'learn_cli.core.validator'
---@brief Validiert Lösungen gegen erwartete Ergebnisse

local Validator = {}

--- Hauptvalidierung
---@param validation table
---@param working_dir string
---@return table result {success: boolean, errors: table}
function Validator.validate(validation, working_dir)
  local old_dir = vim.fn.getcwd()
  vim.fn.chdir(working_dir)

  local result = {
    success = true,
    errors = {},
  }

  -- Type-spezifische Validierung
  if validation.type == "file_content" then
    local file_result = Validator.validate_file_content(validation)
    if not file_result.success then
      result.success = false
      vim.list_extend(result.errors, file_result.errors)
    end
  elseif validation.type == "command_output" then
    local cmd_result = Validator.validate_command_output(validation)
    if not cmd_result.success then
      result.success = false
      vim.list_extend(result.errors, cmd_result.errors)
    end
  elseif validation.type == "pattern" then
    local pattern_result = Validator.validate_pattern(validation)
    if not pattern_result.success then
      result.success = false
      vim.list_extend(result.errors, pattern_result.errors)
    end
  elseif validation.type == "multi" then
    -- Mehrere Checks
    for _, check in ipairs(validation.checks) do
      local check_result = Validator.validate({type = check.type, unpack(check)}, working_dir)
      if not check_result.success then
        result.success = false
        vim.list_extend(result.errors, check_result.errors)
      end
    end
  end

  -- Zusätzliche Checks
  if validation.checks then
    for _, check in ipairs(validation.checks) do
      local check_result = Validator.validate_check(check)
      if not check_result.success then
        result.success = false
        vim.list_extend(result.errors, check_result.errors)
      end
    end
  end

  vim.fn.chdir(old_dir)
  return result
end

--- Validiert Dateiinhalt
---@param validation table
---@return table
function Validator.validate_file_content(validation)
  local file = validation.file

  -- Datei existiert?
  if vim.fn.filereadable(file) == 0 then
    return {
      success = false,
      errors = {string.format("Datei nicht gefunden: %s", file)}
    }
  end

  -- Inhalt lesen
  local lines = vim.fn.readfile(file)
  local actual = table.concat(lines, "\n")

  -- Mit erwartetem Inhalt vergleichen
  local expected = validation.expected
  if validation.expected_from_file then
    local exp_lines = vim.fn.readfile(validation.expected_from_file)
    expected = table.concat(exp_lines, "\n")
  end

  if actual:gsub("%s+$", "") ~= expected:gsub("%s+$", "") then
    return {
      success = false,
      errors = {
        string.format("Inhalt von %s stimmt nicht überein", file),
        string.format("Erwartet:\n%s", expected),
        string.format("Gefunden:\n%s", actual),
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert Command Output
---@param validation table
---@return table
function Validator.validate_command_output(validation)
  local cmd = validation.command
  local expected = validation.expected

  -- Command ausführen
  local output = vim.fn.system(cmd)

  if output:gsub("%s+$", "") ~= expected:gsub("%s+$", "") then
    return {
      success = false,
      errors = {
        string.format("Output von '%s' stimmt nicht überein", cmd),
        string.format("Erwartet:\n%s", expected),
        string.format("Gefunden:\n%s", output),
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert Pattern
---@param validation table
---@return table
function Validator.validate_pattern(validation)
  local file = validation.file
  local pattern = validation.regex
  local forbidden = validation.forbidden_literal

  if vim.fn.filereadable(file) == 0 then
    return {
      success = false,
      errors = {string.format("Datei nicht gefunden: %s", file)}
    }
  end

  local lines = vim.fn.readfile(file)
  local content = table.concat(lines, "\n")

  -- Pattern match
  if not content:match(pattern) then
    return {
      success = false,
      errors = {
        string.format("Inhalt entspricht nicht dem Pattern: %s", pattern),
        string.format("Gefunden: %s", content),
      }
    }
  end

  -- Forbidden literal
  if forbidden and content:find(forbidden, 1, true) then
    return {
      success = false,
      errors = {
        string.format("Datei enthält verbotenen Text: %s", forbidden),
        "Variable wurde nicht expandiert?",
      }
    }
  end

  return {success = true, errors = {}}
end

return Validator

-- ============================================================================
-- SCORER
-- ============================================================================

---@module 'learn_cli.core.scorer'
---@brief Berechnet Punkte für Exercises

local Scorer = {}

--- Berechnet Gesamtpunktzahl
---@param state ExerciseState
---@param duration integer Sekunden
---@return table score
function Scorer.calculate_score(state, duration)
  local exercise = state.exercise
  local scoring = exercise.scoring

  local points = scoring.correct or 100

  -- Zeit-Bonus
  if scoring.time_bonus then
    if duration < 30 and scoring.time_bonus["30s"] then
      points = points + scoring.time_bonus["30s"]
    elseif duration < 60 and scoring.time_bonus["60s"] then
      points = points + scoring.time_bonus["60s"]
    elseif duration < 90 and scoring.time_bonus["90s"] then
      points = points + scoring.time_bonus["90s"]
    end
  end

  -- Hint-Malus
  if scoring.hint_penalty then
    for _, hint_level in ipairs(state.hints_used) do
      local penalty = scoring.hint_penalty[tostring(hint_level)]
      if penalty then
        points = points + penalty  -- penalty ist negativ
      end
    end
  end

  -- Lösung angeschaut
  if state.solution_viewed and scoring.hint_penalty.viewed_solution then
    points = points + scoring.hint_penalty.viewed_solution
  end

  -- Minimum 0
  points = math.max(0, points)

  return {
    total = points,
    max = exercise.points_max,
    percentage = (points / exercise.points_max) * 100,
    time_bonus = (points > exercise.points_max) and (points - exercise.points_max) or 0,
    hints_used = #state.hints_used,
    attempts = state.attempts,
  }
end

return Scorer

-- ============================================================================
-- PROGRESS TRACKING
-- ============================================================================

---@module 'learn_cli.state.progress'
---@brief Speichert und lädt Fortschritt

local Progress = {}

local storage_file = vim.fn.stdpath("data") .. "/learn-cli-progress.json"

--- Lädt gespeicherten Fortschritt
---@return table
function Progress.load()
  if vim.fn.filereadable(storage_file) == 0 then
    return Progress.init_empty()
  end

  local content = vim.fn.readfile(storage_file)
  local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))

  if not ok then
    return Progress.init_empty()
  end

  return data
end

--- Speichert Fortschritt
---@param data table
function Progress.save(data)
  local json = vim.json.encode(data)
  vim.fn.writefile(vim.split(json, "\n"), storage_file)
end

--- Initialisiert leeren Fortschritt
---@return table
function Progress.init_empty()
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

--- Speichert Exercise-Ergebnis
---@param result table
function Progress.save_exercise_result(result)
  local data = Progress.load()

  -- Exercise hinzufügen
  table.insert(data.exercises, result)

  -- Statistiken updaten
  data.statistics.exercises_completed = data.statistics.exercises_completed + 1
  data.statistics.total_time = data.statistics.total_time + result.duration

  if result.score.percentage == 100 then
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
  data.xp = data.xp + 25  -- 25 XP pro Exercise

  -- Level-Up prüfen
  local levels = require("learn_cli.gamification.levels")
  local new_level = levels.calculate_level(data.xp)
  if new_level > data.level then
    data.level = new_level
    require("learn_cli.ui.notifications").level_up(new_level)
  end

  Progress.save(data)

  -- Achievements prüfen
  require("learn_cli.gamification.achievements").check_achievements(data)
end

--- Holt Cycle-Fortschritt
---@param cycle_id string
---@return table
function Progress.get_cycle_progress(cycle_id)
  local data = Progress.load()
  return data.cycles[cycle_id] or {
    current_iteration = 1,
    current_day = 1,
    current_exercise = 1,
  }
end

--- Speichert Cycle-Fortschritt
---@param cycle Cycle
function Progress.save_cycle_progress(cycle)
  local data = Progress.load()
  data.cycles[cycle.metadata.cycle_id] = {
    current_iteration = cycle.current_iteration,
    current_day = cycle.current_day,
    current_exercise = cycle.current_exercise,
  }
  Progress.save(data)
end

return Progress

-- ============================================================================
-- BEISPIEL: Exercise starten (Main Entry Point)
-- ============================================================================

---@module 'learn_cli'
---@brief Haupt-Plugin-Modul

local LearnCli = {}

local cycle_manager = require("learn_cli.core.cycle_manager")
local exercise_runner = require("learn_cli.core.exercise_runner")
local ui = require("learn_cli.ui.dashboard")

--- Startet das Plugin
function LearnCli.start()
  -- Dashboard anzeigen
  ui.show_dashboard()
end

--- Startet einen Cycle
---@param cycle_id string
function LearnCli.start_cycle(cycle_id)
  local cycle, err = cycle_manager.load_cycle(cycle_id)
  if not cycle then
    vim.notify("Fehler beim Laden: " .. err, vim.log.levels.ERROR)
    return
  end

  -- Prüfe ob Info-Einheit gelesen werden muss
  local should_show_info = (cycle.current_day == 1 or cycle.current_day == 4)
  if should_show_info then
    local half_cycle = cycle.current_day <= 3 and "a" or "b"
    local info, info_err = cycle_manager.load_info_unit(
      cycle_id,
      cycle.current_iteration,
      half_cycle
    )
    if info then
      require("learn_cli.ui.info_reader").show(info, function()
        LearnCli.start_current_exercise(cycle)
      end)
      return
    end
  end

  LearnCli.start_current_exercise(cycle)
end

--- Startet aktuelles Exercise
---@param cycle Cycle
function LearnCli.start_current_exercise(cycle)
  local day = cycle_manager.load_day(
    cycle.metadata.cycle_id,
    cycle.current_iteration,
    cycle.current_day
  )

  if not day then
    vim.notify("Fehler beim Laden des Tages", vim.log.levels.ERROR)
    return
  end

  local exercise = day.exercises[cycle.current_exercise]
  if not exercise then
    vim.notify("Exercise nicht gefunden", vim.log.levels.ERROR)
    return
  end

  local working_dir = string.format(
    "/tmp/learn-cli/%s/iter%d/day%02d/ex%02d",
    cycle.metadata.cycle_id,
    cycle.current_iteration,
    cycle.current_day,
    cycle.current_exercise
  )

  local state = exercise_runner.start(exercise, working_dir)

  -- User Commands registrieren
  vim.api.nvim_create_user_command("LearnCliSubmit", function()
    local result = exercise_runner.submit(state)
    if result.success then
      vim.defer_fn(function()
        -- Nächstes Exercise
        local success = cycle_manager.next_exercise(cycle)
        if success then
          LearnCli.start_current_exercise(cycle)
        else
          ui.show_cycle_complete(cycle)
        end
      end, 2000)
    end
  end, {})

  vim.api.nvim_create_user_command("LearnCliHint", function(opts)
    local level = tonumber(opts.args) or 1
    exercise_runner.show_hint(state, level)
  end, {nargs = "?"})

  vim.api.nvim_create_user_command("LearnCliSolution", function()
    exercise_runner.show_solution(state)
  end, {})
end

return LearnCli
