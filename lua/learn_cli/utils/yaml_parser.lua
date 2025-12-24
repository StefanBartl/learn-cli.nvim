---@module 'learn_cli.utils.yaml_parser'
---@brief Einfacher YAML Parser (oder Wrapper für externe Library)

local M = {}

--- Dekodiert YAML String zu Lua Table
---@param yaml_str string
---@return table|nil data, string|nil error
function M.decode(yaml_str)
  -- Option 1: Verwende lyaml falls verfügbar
  local has_lyaml, lyaml = pcall(require, "lyaml")
  if has_lyaml then
    local ok, result = pcall(lyaml.load, yaml_str)
    if ok then
      return result, nil
    else
      return nil, "YAML Parse Error: " .. tostring(result)
    end
  end

  -- Option 2: Fallback auf JSON (wenn YAML zu JSON konvertiert wurde)
  -- Für die initiale Implementation können wir auch JSON verwenden
  local ok, result = pcall(vim.json.decode, yaml_str)
  if ok then
    return result, nil
  end

  -- Option 3: Sehr einfacher manueller Parser (NUR für simple Fälle!)
  -- Dies ist ein minimaler Parser für einfache YAML-Strukturen
  return M.simple_parse(yaml_str)


end

--- Sehr einfacher YAML Parser (nur für Basics)
---@param yaml_str string
---@return table|nil data, string|nil error
function M.simple_parse(yaml_str)
  -- WARNUNG: Dies ist ein SEHR einfacher Parser
  -- Funktioniert nur für simple key: value Strukturen
  -- Für Production sollte lyaml verwendet werden!

  local result = {}
  local current_table = result
  local stack = {}

  for line in yaml_str:gmatch("[^\r\n]+") do
    -- Leerzeilen und Kommentare ignorieren
    if line:match("^%s*$") or line:match("^%s*#") then
      goto continue
    end

    -- Indentation messen
    -- local indent = #line:match("^%s*")
    local content = line:match("^%s*(.+)")

    -- Key: Value
    local key, value = content:match("^([^:]+):%s*(.*)")
    if key then
      key = key:gsub("^%s+", ""):gsub("%s+$", "")
      value = value:gsub("^%s+", ""):gsub("%s+$", "")

      if value == "" then
        -- Nested object
        current_table[key] = {}
        table.insert(stack, current_table)
        current_table = current_table[key]
      else
        -- Parse value
        if value == "true" then
          current_table[key] = true
        elseif value == "false" then
          current_table[key] = false
        elseif value:match("^%d+$") then
          current_table[key] = tonumber(value)
        elseif value:match('^".-"$') or value:match("^'.-'$") then
          current_table[key] = value:sub(2, -2)
        else
          current_table[key] = value
        end
      end
    end

    ::continue::
  end

  return result, nil
end

--- Enkodiert Lua Table zu YAML String
---@param data table
---@return string|nil yaml, string|nil error
function M.encode(data)
  local has_lyaml, lyaml = pcall(require, "lyaml")
  if has_lyaml then
    local ok, result = pcall(lyaml.dump, {data})
    if ok then
      return result, nil
    else
      return nil, "YAML Encode Error: " .. tostring(result)
    end
  end

  -- Fallback: JSON
  local ok, result = pcall(vim.json.encode, data)
  if ok then
    return result, nil
  end

  return nil, "Encoding failed"
end

return M
