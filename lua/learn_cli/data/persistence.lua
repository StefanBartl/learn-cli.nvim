---@module 'learn_cli.data.persistence'
---@brief Save and load plugin state to/from disk
---@description
--- Handles serialization and deserialization of plugin state,
--- including progress, scores, and session data.

local config = require("learn_cli.config")
local state = require("learn_cli.state")

---@class LearnCLI.Persistence
local M = {}

---Get the state file path
---@return string path Full path to state file
local function get_state_file()
  local data_dir = config.get("data_dir")
  return data_dir .. "/state.json"
end

---Serialize state to JSON string
---@param data table State data to serialize
---@return string|nil json Serialized JSON or nil on error
---@return string|nil error Error message if failed
local function serialize(data)
  local ok, result = pcall(vim.json.encode, data)

  if not ok then
    return nil, "Failed to serialize state: " .. tostring(result)
  end

  return result, nil
end

---Deserialize JSON string to table
---@param json string JSON string to deserialize
---@return table|nil data Deserialized data or nil on error
---@return string|nil error Error message if failed
local function deserialize(json)
  local ok, result = pcall(vim.json.decode, json)

  if not ok then
    return nil, "Failed to deserialize state: " .. tostring(result)
  end

  return result, nil
end

---Save current state to disk
---@return LearnCLI.OperationResult result Operation result
function M.save()
  local ok, result = pcall(function()
    local snapshot = state.get_snapshot()

    -- Check if snapshot is valid
    if not snapshot or type(snapshot) ~= "table" then
      return {
        ok = false,
        error = "Invalid snapshot: snapshot is nil or not a table",
        data = nil
      }
    end

    -- Serialize state
    local json, err = serialize(snapshot)
    if not json then
      return {
        ok = false,
        error = err,
        data = nil
      }
    end

    -- Write to file
    local file_path = get_state_file()
    local file = io.open(file_path, "w")

    if not file then
      return {
        ok = false,
        error = "Failed to open state file for writing: " .. file_path,
        data = nil
      }
    end

    file:write(json)
    file:close()

    return {
      ok = true,
      error = nil,
      data = { path = file_path }
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Save operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

---Load state from disk
---@return LearnCLI.OperationResult result Operation result with loaded state
function M.load()
  local ok, result = pcall(function()
    local file_path = get_state_file()

    -- Check if file exists
    if vim.fn.filereadable(file_path) ~= 1 then
      return {
        ok = true,
        error = nil,
        data = nil -- No state file yet, not an error
      }
    end

    -- Read file
    local file = io.open(file_path, "r")

    if not file then
      return {
        ok = false,
        error = "Failed to open state file for reading: " .. file_path,
        data = nil
      }
    end

    local json = file:read("*all")
    file:close()

    -- Deserialize
    local data, err = deserialize(json)
    if not data then
      return {
        ok = false,
        error = err,
        data = nil
      }
    end

    return {
      ok = true,
      error = nil,
      data = data
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Load operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

---Create a backup of the current state file
---@return LearnCLI.OperationResult result Operation result
function M.backup()
  local ok, result = pcall(function()
    local file_path = get_state_file()

    if vim.fn.filereadable(file_path) ~= 1 then
      return {
        ok = false,
        error = "No state file to backup",
        data = nil
      }
    end

    local backup_path = file_path .. ".backup." .. os.time()
    local success = vim.loop.fs_copyfile(file_path, backup_path)

    if not success then
      return {
        ok = false,
        error = "Failed to create backup",
        data = nil
      }
    end

    return {
      ok = true,
      error = nil,
      data = { path = backup_path }
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Backup operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

---Export state to a custom location
---@param export_path string Path to export state to
---@return LearnCLI.OperationResult result Operation result
function M.export(export_path)
  local ok, result = pcall(function()
    local snapshot = state.get_snapshot()

    -- Check if snapshot is valid
    if not snapshot or type(snapshot) ~= "table" then
      return {
        ok = false,
        error = "Invalid snapshot: cannot export nil or non-table snapshot",
        data = nil
      }
    end

    -- Serialize
    local json, err = serialize(snapshot)
    if not json then
      return {
        ok = false,
        error = err,
        data = nil
      }
    end

    -- Write to export path
    local file = io.open(export_path, "w")

    if not file then
      return {
        ok = false,
        error = "Failed to open export file: " .. export_path,
        data = nil
      }
    end

    file:write(json)
    file:close()

    return {
      ok = true,
      error = nil,
      data = { path = export_path }
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Export operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

---Import state from a file
---@param import_path string Path to import state from
---@return LearnCLI.OperationResult result Operation result
function M.import(import_path)
  local ok, result = pcall(function()
    -- Read file
    if vim.fn.filereadable(import_path) ~= 1 then
      return {
        ok = false,
        error = "Import file not readable: " .. import_path,
        data = nil
      }
    end

    local file = io.open(import_path, "r")

    if not file then
      return {
        ok = false,
        error = "Failed to open import file: " .. import_path,
        data = nil
      }
    end

    local json = file:read("*all")
    file:close()

    -- Deserialize
    local data, err = deserialize(json)
    if not data then
      return {
        ok = false,
        error = err,
        data = nil
      }
    end

    -- Restore to state
    local restore_result = state.restore_snapshot(data)
    if not restore_result.ok then
      return restore_result
    end

    -- Save the imported state
    M.save()

    return {
      ok = true,
      error = nil,
      data = data
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Import operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end

return M
