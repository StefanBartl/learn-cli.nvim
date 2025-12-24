---@module 'learn_cli.config'
---@brief Configuration management with lazy-loading and validation
---@description
--- Manages plugin configuration with default resolution, validation,
--- and lazy initialization of nested fields.

local defaults = require("learn_cli.config.defaults").defaults

---@class ConfigManager
local M = {}

---@type LearnCLI.Config|nil
M._config = nil

---@type boolean
M._initialized = false

---Deep merge two tables, with values from 'override' taking precedence
---@param base table Base configuration table
---@param override table User overrides
---@return table merged The merged configuration
local function deep_merge(base, override)
  local result = vim.deepcopy(base)

  for k, v in pairs(override) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = deep_merge(result[k], v)
    else
      result[k] = v
    end
  end

  return result
end

---Resolve computed defaults (paths, etc.)
---@param config LearnCLI.Config Configuration to process
---@return LearnCLI.Config resolved Resolved configuration
local function resolve_defaults(config)
  -- Set cache_dir if not provided
  if not config.cache_dir then
    config.cache_dir = config.data_dir .. "/cache"
  end

  -- Set exercises_dir if not provided (use plugin's built-in exercises)
  if not config.exercises_dir then
    local plugin_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h:h")
    config.exercises_dir = plugin_root .. "/lua/learn_cli/data/exercises"
  end

  return config
end

---Validate configuration structure
---@param config LearnCLI.Config Configuration to validate
---@return LearnCLI.ValidationResult result Validation result with details
local function validate_config(config)
  local errors = {}

  -- Validate required fields
  if type(config.data_dir) ~= "string" or config.data_dir == "" then
    table.insert(errors, "data_dir must be a non-empty string")
  end

  -- Validate scoring parameters
  if config.scoring.base_score < 0 or config.scoring.base_score > 100 then
    table.insert(errors, "scoring.base_score must be between 0 and 100")
  end

  if config.scoring.hint_penalty < 0 then
    table.insert(errors, "scoring.hint_penalty cannot be negative")
  end

  -- Validate timer thresholds
  if config.timer.warning_at_percent < 0 or config.timer.warning_at_percent > 1 then
    table.insert(errors, "timer.warning_at_percent must be between 0 and 1")
  end

  if #errors > 0 then
    return {
      valid = false,
      message = "Configuration validation failed",
      details = errors
    }
  end

  return {
    valid = true,
    message = "Configuration is valid",
    details = nil
  }
end

---Initialize configuration with user options
---@param user_config table|nil User-provided configuration overrides
---@return LearnCLI.OperationResult result Operation result
function M.setup(user_config)
  local ok, result = pcall(function()
    -- Merge user config with defaults
    local config = user_config and deep_merge(defaults, user_config) or vim.deepcopy(defaults)

    -- Resolve computed values
    config = resolve_defaults(config)

    -- Validate
    local validation = validate_config(config)
    if not validation.valid then
      local error_msg = validation.message
      if validation.details and type(validation.details) == "table" then
        error_msg = error_msg .. ": " .. table.concat(validation.details, ", ")
      end

      return {
        ok = false,
        error = error_msg,
        data = nil
      }
    end

    -- Store config
    M._config = config
    M._initialized = true

    -- Ensure directories exist
    vim.fn.mkdir(config.data_dir, "p")
    vim.fn.mkdir(config.cache_dir, "p")

    return {
      ok = true,
      error = nil,
      data = config
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Configuration setup failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

---Get configuration value by key path (e.g., "ui.dashboard.width")
---@param key_path string Dot-separated path to config value
---@return any|nil value The configuration value or nil if not found
function M.get(key_path)
  if not M._initialized then
    M.setup(nil) -- Initialize with defaults if not done
  end

  local keys = vim.split(key_path, ".", { plain = true })
  local value = M._config

  for _, key in ipairs(keys) do
    if type(value) ~= "table" then
      return nil
    end
    value = value[key]
  end

  return value
end

---Get full configuration object
---@return LearnCLI.Config config Complete configuration
function M.get_all()
  if not M._initialized then
    M.setup(nil)
  end

  -- Ensure _config is not nil before deepcopy
  if not M._config then
    -- Initialize with defaults if somehow still nil
    M.setup(nil)
  end

  return vim.deepcopy(M._config or defaults)
end

---Check if configuration is initialized
---@return boolean initialized Whether config is initialized
function M.is_initialized()
  return M._initialized
end

---Reset configuration to defaults (mainly for testing)
---@return nil
function M.reset()
  M._config = nil
  M._initialized = false
end

return M
