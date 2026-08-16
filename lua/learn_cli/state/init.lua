---@module 'learn_cli.state'
---@brief Central state management for learn_cli
---@description
--- Manages cycle progress, current exercise, and loaded data.
--- Provides safe access with validation and defaults.

local M = {}

-- Dependencies
local config = require('learn_cli.config')
local loader = require('learn_cli.loader')

-- Forward declarations
local load_cycle_metadata
local load_exercises
local load_info_files

-- Internal state
local current_cycle = 'cycle_01'
local current_iteration = 1
local current_day = 1
local current_exercise = 1

---@type LearnCLI.CycleMetadata?
local cycle_metadata = nil

---@type LearnCLI.ExerciseData[]?
local exercises = nil

---@type LearnCLI.InfoFileMap?
local info_files = nil

--- Load cycle metadata. Delegates the actual file read + YAML parse to
--- `learn_cli.loader` (already migrated onto `lib.nvim.fs.read`) — this
--- used to carry its own byte-for-byte copy of that logic, which drifted
--- into a second, unmigrated implementation. Only the field-defaulting
--- shape specific to `LearnCLI.CycleMetadata` (`difficulty`/`topics`)
--- stays local, since `loader.load_cycle_metadata` doesn't apply it.
---@param cycle_name string
---@return LearnCLI.CycleMetadata? metadata
---@return string? error
load_cycle_metadata = function(cycle_name)
  if type(cycle_name) ~= 'string' or cycle_name == '' then
    return nil, 'Invalid cycle name'
  end

  local data, err = loader.load_cycle_metadata(cycle_name)
  if not data then
    return nil, err
  end

  return {
    name = data.name or cycle_name,
    description = data.description or 'No description',
    iterations = tonumber(data.iterations) or 3,
    days = tonumber(data.days) or 7,
    difficulty = data.difficulty or 'unknown',
    topics = {},
  }
end

--- Load exercises for specific day. Delegates to `learn_cli.loader`; only
--- the input validation (returning a descriptive error instead of letting
--- a bad argument reach `string.format`) stays local.
---@param cycle_name string
---@param iteration integer
---@param day integer
---@return LearnCLI.ExerciseData[]? exercises
---@return string? error
load_exercises = function(cycle_name, iteration, day)
  if type(cycle_name) ~= 'string' then
    return nil, 'Invalid cycle name'
  end
  if type(iteration) ~= 'number' or iteration < 1 then
    return nil, 'Invalid iteration'
  end
  if type(day) ~= 'number' or day < 1 then
    return nil, 'Invalid day'
  end

  return loader.load_exercises(cycle_name, iteration, day)
end

--- Load info markdown files. Delegates to `learn_cli.loader`.
---@param cycle_name string
---@param iteration integer
---@param day integer
---@return LearnCLI.InfoFileMap
load_info_files = function(cycle_name, iteration, day)
  return loader.load_info_files(cycle_name, iteration, day)
end

--- Initialize state from saved progress or defaults
---@return boolean success
---@return string? error
function M.init()
  -- Validate cycle exists
  local cycle_path = config.get_cycle_path(current_cycle)
  if vim.fn.isdirectory(cycle_path) == 0 then
    return false, string.format('Cycle not found: %s', current_cycle)
  end

  -- Load metadata
  local meta, err = load_cycle_metadata(current_cycle)
  if not meta then
    return false, err
  end
  cycle_metadata = meta

  -- Load current day data
  return M.reload_current_day()
end

--- Reload exercises and info for current day
---@return boolean success
---@return string? error
function M.reload_current_day()
  local ex, err = load_exercises(current_cycle, current_iteration, current_day)

  if not ex then
    exercises = {}
    return false, err
  end

  exercises = ex
  info_files = load_info_files(current_cycle, current_iteration, current_day)

  return true
end

--- Get cycle metadata with safe defaults
---@return LearnCLI.CycleMetadata
function M.get_cycle_info()
  if not cycle_metadata then
    return {
      name = current_cycle,
      description = 'No description',
      iterations = 0,
      days = 0,
      difficulty = 'unknown',
      topics = {},
    }
  end

  return cycle_metadata
end

--- Get current progress
---@return LearnCLI.ProgressInfo
function M.get_progress()
  local info = M.get_cycle_info()

  return {
    current_day = current_day,
    total_days = info.days,  -- Use days field from CycleMetadata
    current_iteration = current_iteration,
    total_iterations = info.iterations,  -- Use iterations field from CycleMetadata
    current_exercise = current_exercise,
    total_exercises = exercises and #exercises or 0,
  }
end

--- Get current exercise data
---@return LearnCLI.ExerciseData?
function M.get_current_exercise()
  if not exercises or #exercises == 0 then
    return nil
  end

  for _, ex in ipairs(exercises) do
    if ex.id == current_exercise then
      return ex
    end
  end

  return nil
end

--- Get info content by suffix
---@param suffix string
---@return string?
function M.get_info_content(suffix)
  if type(suffix) ~= 'string' then
    return nil
  end

  if not info_files then
    return nil
  end

  return info_files[suffix]
end

--- Move to next exercise
---@return boolean success
function M.next_exercise()
  if not exercises or #exercises == 0 then
    return false
  end

  if current_exercise < #exercises then
    current_exercise = current_exercise + 1
    return true
  end

  return false
end

--- Move to previous exercise
---@return boolean success
function M.prev_exercise()
  if not exercises or #exercises == 0 then
    return false
  end

  if current_exercise > 1 then
    current_exercise = current_exercise - 1
    return true
  end

  return false
end

--- Move to next day
---@return boolean success
function M.next_day()
  local info = M.get_cycle_info()

  if current_day < info.days then
    current_day = current_day + 1
    current_exercise = 1
    M.reload_current_day()
    return true
  end

  return false
end

--- Move to previous day
---@return boolean success
function M.prev_day()
  if current_day > 1 then
    current_day = current_day - 1
    current_exercise = 1
    M.reload_current_day()
    return true
  end

  return false
end

--- Reset progress
---@return nil
function M.reset_progress()
  current_day = 1
  current_iteration = 1
  current_exercise = 1
  M.reload_current_day()
end

--- Set current cycle
---@param cycle_name string
---@return boolean success
---@return string? error
function M.set_cycle(cycle_name)
  if type(cycle_name) ~= 'string' or cycle_name == '' then
    return false, 'Invalid cycle name'
  end

  local cycle_path = config.get_cycle_path(cycle_name)
  if vim.fn.isdirectory(cycle_path) == 0 then
    return false, 'Cycle not found'
  end

  current_cycle = cycle_name
  current_day = 1
  current_iteration = 1
  current_exercise = 1

  return M.init()
end

return M
