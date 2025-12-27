---@module 'learn_cli.loader'
---@brief Loads exercises, info files, and metadata with robust error handling
---@description
--- Provides safe loading of cycle data with comprehensive validation
--- and fallback mechanisms for missing files.

local M = {}
local config = require('learn_cli.config')

--- Safe file read with error handling
---@param filepath string Path to file
---@return string? content File content or nil if failed
---@return string? error Error message if failed
local function safe_read_file(filepath)
  if vim.fn.filereadable(filepath) == 0 then
    return nil, string.format('File not found: %s', filepath)
  end

  local file, err = io.open(filepath, 'r')
  if not file then
    return nil, string.format('Failed to open file: %s (%s)', filepath, err or 'unknown')
  end

  local content = file:read('*a')
  file:close()

  if not content or content == '' then
    return nil, string.format('Empty file: %s', filepath)
  end

  return content
end

--- Parse YAML content (simple implementation)
---@param content string YAML content
---@return table? parsed Parsed data or nil if failed
---@return string? error Error message if failed
local function parse_yaml(content)
  local result = {}

  -- Simple YAML parser (for basic key-value and lists)
  for line in content:gmatch('[^\r\n]+') do
    -- Skip comments and empty lines
    if not line:match('^%s*#') and not line:match('^%s*$') then
      -- Parse key: value
      local key, value = line:match('^([%w_]+):%s*(.*)$')
      if key and value then
        -- Remove quotes
        value = value:gsub('^["\']', ''):gsub('["\']$', '')

        -- Try to convert to number
        local num = tonumber(value)
        result[key] = num or value
      end
    end
  end

  return result
end

--- Load cycle metadata
---@param cycle_name string Cycle name (e.g. "cycle_01")
---@return table? metadata Cycle metadata or nil if failed
---@return string? error Error message if failed
function M.load_cycle_metadata(cycle_name)
  local cycle_path = config.get_cycle_path(cycle_name)
  local metadata_file = cycle_path .. '/metadata.yaml'

  local content, err = safe_read_file(metadata_file)
  if not content then
    return nil, err
  end

  local metadata = parse_yaml(content)
  if not metadata then
    return nil, 'Failed to parse metadata.yaml'
  end

  -- Ensure required fields with defaults
  metadata.name = metadata.name or cycle_name
  metadata.iterations = tonumber(metadata.iterations) or 3
  metadata.days = tonumber(metadata.days) or 7
  metadata.description = metadata.description or 'No description'

  return metadata
end

--- Load exercises for a specific day
---@param cycle_name string Cycle name
---@param iteration integer Iteration number (1-based)
---@param day integer Day number (1-based)
---@return table? exercises List of exercises or nil if failed
---@return string? error Error message if failed
function M.load_exercises(cycle_name, iteration, day)
  local cycle_path = config.get_cycle_path(cycle_name)
  local exercises_file = string.format(
    '%s/iteration_%d/day_%02d/exercises.yaml',
    cycle_path, iteration, day
  )

  local content, err = safe_read_file(exercises_file)
  if not content then
    return nil, err
  end

  -- Simple exercise parsing
  local exercises = {}
  local current_ex = nil

  for line in content:gmatch('[^\r\n]+') do
    -- Skip comments
    if not line:match('^%s*#') and not line:match('^%s*$') then
      -- New exercise
      if line:match('^%s*-%s*id:') then
        if current_ex then
          table.insert(exercises, current_ex)
        end
        current_ex = { id = tonumber(line:match('id:%s*(%d+)')) }
      elseif current_ex then
        -- Parse exercise fields
        local key, value = line:match('^%s*([%w_]+):%s*(.*)$')
        if key and value then
          value = value:gsub('^["\']', ''):gsub('["\']$', '')
          current_ex[key] = value
        end
      end
    end
  end

  -- Add last exercise
  if current_ex then
    table.insert(exercises, current_ex)
  end

  if #exercises == 0 then
    return nil, 'No exercises found in file'
  end

  return exercises
end

--- Load info markdown files for a day
---@param cycle_name string Cycle name
---@param iteration integer Iteration number
---@param day integer Day number
---@return table info_files Map of info file suffixes to content
function M.load_info_files(cycle_name, iteration, day)
  local cycle_path = config.get_cycle_path(cycle_name)
  local day_path = string.format(
    '%s/iteration_%d/day_%02d',
    cycle_path, iteration, day
  )

  local info_files = {}

  -- Try to load info_a.md through info_d.md
  for _, suffix in ipairs({'a', 'b', 'c', 'd'}) do
    local info_file = string.format('%s/info_%s.md', day_path, suffix)
    local content = safe_read_file(info_file)

    if content then
      info_files[suffix] = content
    else
      -- Log warning but don't fail
      vim.notify(
        string.format('Info file not found: info_%s.md (Day %d)', suffix, day),
        vim.log.levels.DEBUG,
        { title = 'Learn CLI' }
      )
    end
  end

  return info_files
end

--- Get exercise by ID
---@param exercises table[] List of exercises
---@param exercise_id integer Exercise ID to find
---@return table? exercise Exercise data or nil if not found
function M.get_exercise_by_id(exercises, exercise_id)
  for _, ex in ipairs(exercises) do
    if ex.id == exercise_id then
      return ex
    end
  end
  return nil
end

--- Validate cycle structure
---@param cycle_name string Cycle name to validate
---@return boolean valid True if cycle structure is valid
---@return string? error Error message if invalid
function M.validate_cycle(cycle_name)
  local cycle_path = config.get_cycle_path(cycle_name)

  -- Check if cycle directory exists
  if vim.fn.isdirectory(cycle_path) == 0 then
    return false, string.format('Cycle directory not found: %s', cycle_path)
  end

  -- Check if metadata exists
  local metadata, err = M.load_cycle_metadata(cycle_name)
  if not metadata then
    return false, err
  end

  -- Check if at least one iteration exists
  local iter1_path = cycle_path .. '/iteration_1'
  if vim.fn.isdirectory(iter1_path) == 0 then
    return false, 'No iterations found in cycle'
  end

  -- Check if at least day_01 exists
  local day1_path = iter1_path .. '/day_01'
  if vim.fn.isdirectory(day1_path) == 0 then
    return false, 'No days found in iteration_1'
  end

  return true
end

return M
