---@module 'learn_cli.core.validator'
---@brief Validiert Exercise-Lösungen

local M = {}

--- Hauptvalidierung
---@param validation table Validation configuration
---@param working_dir string Working directory path
---@return table result {success: boolean, errors: string[]}
function M.validate(validation, working_dir)
  local old_dir = vim.fn.getcwd()

  -- Wechsle in Working Directory
  local ok = pcall(function() vim.cmd("cd " .. working_dir) end)
  if not ok then
    return {
      success = false,
      errors = {"Konnte nicht in Working Directory wechseln"}
    }
  end

  local result = {
    success = true,
    errors = {},
  }

  -- Type-spezifische Validierung
  local validation_type = validation.type

  if validation_type == "file_content" then
    local file_result = M.validate_file_content(validation)
    if not file_result.success then
      result.success = false
      vim.list_extend(result.errors, file_result.errors)
    end

  elseif validation_type == "file_exists" then
    local exists_result = M.validate_file_exists(validation)
    if not exists_result.success then
      result.success = false
      vim.list_extend(result.errors, exists_result.errors)
    end

  elseif validation_type == "command_output" then
    local cmd_result = M.validate_command_output(validation)
    if not cmd_result.success then
      result.success = false
      vim.list_extend(result.errors, cmd_result.errors)
    end

  elseif validation_type == "command_output_unordered" then
    local unord_result = M.validate_command_output_unordered(validation)
    if not unord_result.success then
      result.success = false
      vim.list_extend(result.errors, unord_result.errors)
    end

  elseif validation_type == "command_success" then
    local success_result = M.validate_command_success(validation)
    if not success_result.success then
      result.success = false
      vim.list_extend(result.errors, success_result.errors)
    end

  elseif validation_type == "command_contains" then
    local contains_result = M.validate_command_contains(validation)
    if not contains_result.success then
      result.success = false
      vim.list_extend(result.errors, contains_result.errors)
    end

  elseif validation_type == "pattern" then
    local pattern_result = M.validate_pattern(validation)
    if not pattern_result.success then
      result.success = false
      vim.list_extend(result.errors, pattern_result.errors)
    end

  elseif validation_type == "multi" then
    -- Multiple Checks
    for _, check in ipairs(validation.checks or {}) do
      local check_result = M.validate(check, working_dir)
      if not check_result.success then
        result.success = false
        vim.list_extend(result.errors, check_result.errors)
      end
    end
  else
    result.success = false
    table.insert(result.errors, "Unbekannter Validierungs-Typ: " .. tostring(validation_type))
  end

  -- Zusätzliche Checks
  if validation.checks then
    for _, check in ipairs(validation.checks) do
      local check_result = M.validate(check, working_dir)
      if not check_result.success then
        result.success = false
        vim.list_extend(result.errors, check_result.errors)
      end
    end
  end

  -- Zurück zum Original Directory
  vim.cmd("cd " .. old_dir)

  return result
end

--- Validiert Dateiinhalt
---@param validation table
---@return table
function M.validate_file_content(validation)
  local file = validation.file

  if vim.fn.filereadable(file) == 0 then
    return {
      success = false,
      errors = {string.format("❌ Datei nicht gefunden: %s", file)}
    }
  end

  local lines = vim.fn.readfile(file)
  local actual = table.concat(lines, "\n")

  -- Expected content ermitteln
  local expected
  if validation.expected_from_file then
    local exp_lines = vim.fn.readfile(validation.expected_from_file)
    expected = table.concat(exp_lines, "\n")
  else
    expected = validation.expected
  end

  -- Trailing whitespace normalisieren
  actual = actual:gsub("%s+$", "")
  expected = expected:gsub("%s+$", "")

  if actual ~= expected then
    return {
      success = false,
      errors = {
        string.format("❌ Inhalt von '%s' stimmt nicht überein", file),
        "",
        "📋 Erwartet:",
        expected,
        "",
        "📄 Gefunden:",
        actual,
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert ob Datei existiert
---@param validation table
---@return table
function M.validate_file_exists(validation)
  local file = validation.file

  if vim.fn.filereadable(file) == 0 then
    return {
      success = false,
      errors = {string.format("❌ Datei nicht gefunden: %s", file)}
    }
  end

  return {success = true, errors = {}}
end

--- Validiert Command Output
---@param validation table
---@return table
function M.validate_command_output(validation)
  local cmd = validation.command
  local expected = validation.expected

  local output = vim.fn.system(cmd)

  -- Exit code prüfen
  if vim.v.shell_error ~= 0 then
    return {
      success = false,
      errors = {
        string.format("❌ Befehl fehlgeschlagen: %s", cmd),
        string.format("Exit code: %d", vim.v.shell_error),
        string.format("Output: %s", output),
      }
    }
  end

  -- Output normalisieren
  output = output:gsub("%s+$", "")
  expected = expected:gsub("%s+$", "")

  if output ~= expected then
    return {
      success = false,
      errors = {
        string.format("❌ Output von '%s' stimmt nicht überein", cmd),
        "",
        "📋 Erwartet:",
        expected,
        "",
        "📄 Gefunden:",
        output,
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert Command Output (Zeilen ungeordnet)
---@param validation table
---@return table
function M.validate_command_output_unordered(validation)
  local cmd = validation.command
  local expected_lines = validation.expected_lines

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return {
      success = false,
      errors = {
        string.format("❌ Befehl fehlgeschlagen: %s", cmd),
      }
    }
  end

  local actual_lines = vim.split(output:gsub("%s+$", ""), "\n")

  -- Sortiere beide Listen
  table.sort(actual_lines)
  table.sort(expected_lines)

  local actual_str = table.concat(actual_lines, "\n")
  local expected_str = table.concat(expected_lines, "\n")

  if actual_str ~= expected_str then
    return {
      success = false,
      errors = {
        string.format("❌ Output von '%s' enthält nicht die erwarteten Zeilen", cmd),
        "",
        "📋 Erwartet:",
        expected_str,
        "",
        "📄 Gefunden:",
        actual_str,
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert dass Command erfolgreich ausgeführt wird
---@param validation table
---@return table
function M.validate_command_success(validation)
  local cmd = validation.command

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return {
      success = false,
      errors = {
        string.format("❌ Befehl fehlgeschlagen: %s", cmd),
        string.format("Exit code: %d", vim.v.shell_error),
        string.format("Output: %s", output),
      }
    }
  end

  return {success = true, errors = {}}
end

--- Validiert dass Command Output bestimmte Strings enthält
---@param validation table
---@return table
function M.validate_command_contains(validation)
  local cmd = validation.command
  local must_contain = validation.must_contain

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return {
      success = false,
      errors = {string.format("❌ Befehl fehlgeschlagen: %s", cmd)}
    }
  end

  local errors = {}
  for _, str in ipairs(must_contain) do
    if not output:find(str, 1, true) then
      table.insert(errors, string.format("❌ Output enthält nicht: '%s'", str))
    end
  end

  if #errors > 0 then
    return {
      success = false,
      errors = errors,
    }
  end

  return {success = true, errors = {}}
end

--- Validiert mit Pattern/Regex
---@param validation table
---@return table
function M.validate_pattern(validation)
  local file = validation.file
  local pattern = validation.regex
  local forbidden = validation.forbidden_literal

  if vim.fn.filereadable(file) == 0 then
    return {
      success = false,
      errors = {string.format("❌ Datei nicht gefunden: %s", file)}
    }
  end

  local lines = vim.fn.readfile(file)
  local content = table.concat(lines, "\n")

  -- Pattern match
  if not content:match(pattern) then
    return {
      success = false,
      errors = {
        string.format("❌ Inhalt entspricht nicht dem Pattern: %s", pattern),
        string.format("📄 Gefunden: %s", content),
      }
    }
  end

  -- Forbidden literal
  if forbidden and content:find(forbidden, 1, true) then
    return {
      success = false,
      errors = {
        string.format("❌ Datei enthält verbotenen Text: '%s'", forbidden),
        "💡 Tipp: Variable wurde nicht expandiert?",
      }
    }
  end

  return {success = true, errors = {}}
end

return M
