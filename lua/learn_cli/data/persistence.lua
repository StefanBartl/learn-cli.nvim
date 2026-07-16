---@module 'learn_cli.data.persistence'
---@brief Save and load plugin state to/from disk
---@description
--- Handles serialization and deserialization of plugin state,
--- including progress, scores, and session data.
---
--- I/O goes through lib.nvim.fs.json (atomic write, JSON encode/decode) and
--- lib.nvim.cross.fs.mutate (backup copy) rather than hand-rolled
--- io.open/vim.json.encode calls. The `LearnCLI.OperationResult` contract
--- (`{ ok, error, data }`) is unchanged, so this is an internal swap only.

local config = require("learn_cli.config")
local state = require("learn_cli.state")
local json = require("lib.nvim.fs.json")
local fsops = require("lib.nvim.cross.fs.mutate")

---@class LearnCLI.Persistence
local M = {}

---Get the state file path
---@return string path Full path to state file
local function get_state_file()
  local data_dir = config.get("data_dir")
  return data_dir .. "/state.json"
end

---Save current state to disk
---@return LearnCLI.OperationResult result Operation result
function M.save()
  local ok, result = pcall(function()
    local snapshot = state.get_snapshot()

    if not snapshot or type(snapshot) ~= "table" then
      return {
        ok = false,
        error = "Invalid snapshot: snapshot is nil or not a table",
        data = nil
      }
    end

    local file_path = get_state_file()
    local write_ok, write_err = json.write(file_path, snapshot)
    if not write_ok then
      return {
        ok = false,
        error = write_err,
        data = nil
      }
    end

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

    -- Missing state file is expected on first run, not an error — checked
    -- before reading so that case never goes through json.read's error path.
    if vim.fn.filereadable(file_path) ~= 1 then
      return {
        ok = true,
        error = nil,
        data = nil
      }
    end

    local data, err = json.read(file_path)
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
    local copy_ok, copy_err = fsops.copy_file(file_path, backup_path)

    if not copy_ok then
      return {
        ok = false,
        error = "Failed to create backup: " .. tostring(copy_err),
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

    if not snapshot or type(snapshot) ~= "table" then
      return {
        ok = false,
        error = "Invalid snapshot: cannot export nil or non-table snapshot",
        data = nil
      }
    end

    local write_ok, write_err = json.write(export_path, snapshot)
    if not write_ok then
      return {
        ok = false,
        error = write_err,
        data = nil
      }
    end

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
    if vim.fn.filereadable(import_path) ~= 1 then
      return {
        ok = false,
        error = "Import file not readable: " .. import_path,
        data = nil
      }
    end

    local data, err = json.read(import_path)
    if not data then
      return {
        ok = false,
        error = err,
        data = nil
      }
    end

    local restore_result = state.restore_snapshot(data)
    if not restore_result.ok then
      return restore_result
    end

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
