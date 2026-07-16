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

--- Einfacher YAML Parser (nur für Basics). Delegiert an lib.lua.yaml, das
--- (anders als die vorherige Eigenimplementierung hier) Einrückungsebenen
--- korrekt trackt — die alte Version hat ihren Nesting-Stack nie wieder
--- verlassen, sodass alles nach dem ersten verschachtelten Block fälschlich
--- darin landete.
---@param yaml_str string
---@return table|nil data, string|nil error
function M.simple_parse(yaml_str)
  return require("lib.lua.yaml").simple_parse(yaml_str)
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
