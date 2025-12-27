---@module 'learn_cli.template_generator'
---@brief Generates cycle templates with full directory structure
---@description
--- Creates complete cycle templates including:
--- - Cycle directories with metadata
--- - Iteration and day folders
--- - Exercise YAML files with examples
--- - Info markdown files for learning material
--- - Command reference documentation

local M = {}

-- Dependencies
local config = require('learn_cli.config')

-- Forward declarations
local ensure_dir
local write_file
local generate_metadata
local generate_exercises
local generate_info
local generate_reference

--- Create directory if it doesn't exist
---@param path string
---@return boolean success
---@return string? error
ensure_dir = function(path)
  if type(path) ~= 'string' or path == '' then
    return false, 'Invalid path'
  end

  if vim.fn.isdirectory(path) == 1 then
    return true
  end

  local ok = vim.fn.mkdir(path, 'p')
  if ok == 0 then
    return false, string.format('Failed to create: %s', path)
  end

  return true
end

--- Write content to file
---@param filepath string
---@param content string
---@return boolean success
---@return string? error
write_file = function(filepath, content)
  if type(filepath) ~= 'string' or filepath == '' then
    return false, 'Invalid filepath'
  end
  if type(content) ~= 'string' then
    return false, 'Invalid content'
  end

  local ok, file = pcall(io.open, filepath, 'w')
  if not ok or not file then
    return false, string.format('Failed to open: %s', filepath)
  end

  file:write(content)
  file:close()

  return true
end

--- Generate metadata.yaml content
---@param cycle_name string
---@param iterations integer
---@param days integer
---@return string
generate_metadata = function(cycle_name, iterations, days)
  return string.format([[# %s Metadata
name: %s
description: "CLI commands learning cycle"
iterations: %d
days: %d
difficulty: beginner
topics:
  - grep
  - find
  - sed
  - awk
]], cycle_name, cycle_name, iterations, days)
end

--- Generate exercises.yaml content
---@param day integer
---@return string
generate_exercises = function(day)
  return string.format([[# Day %d Exercises
exercises:
  - id: 1
    title: "Basic Pattern Search"
    difficulty: easy
    command: grep
    description: "Search for a pattern in files"
    hints:
      - "Use grep with -r for recursive search"
      - "Use -n to show line numbers"
    solution: "grep -rn 'pattern' /path"

  - id: 2
    title: "Find Files by Name"
    difficulty: medium
    command: find
    description: "Locate files matching criteria"
    hints:
      - "Use -name for pattern matching"
      - "Wildcards need quotes"
    solution: "find . -name '*.txt'"
]], day)
end

--- Generate info markdown content
---@param day integer
---@param suffix string
---@return string
generate_info = function(day, suffix)
  return string.format([[# Day %d - Section %s

## Overview
Learn fundamental CLI command usage and patterns.

## Key Concepts
- Command structure and syntax
- Options and flags
- Input/output redirection
- Piping commands

## Today's Commands
### grep - Pattern Searching
Search for text patterns in files.

### find - File System Search
Locate files and directories by various criteria.

## Practice Tips
1. Read man pages: `man command`
2. Try variations of each command
3. Combine commands with pipes
4. Test on sample data first

## Resources
- GNU Grep Manual: https://www.gnu.org/software/grep/manual/
- Find Command Guide: https://www.gnu.org/software/findutils/
]], day, suffix:upper())
end

--- Generate command reference
---@param command string
---@return string
generate_reference = function(command)
  return string.format([[# %s Command Reference

## Description
%s is a command-line utility for...

## Basic Syntax
```bash
%s [options] [arguments]
```

## Common Options
- `-option1`: Description
- `-option2`: Description

## Examples

### Example 1: Basic Usage
```bash
%s simple-example
```

### Example 2: Advanced Usage
```bash
%s advanced-example
```

## See Also
- `man %s` - Full manual page
- Related commands: ...

## Tips and Tricks
- Tip 1
- Tip 2
]], command, command, command, command, command, command)
end

--- Create complete cycle template
---@param opts LearnCLI.CycleTemplateOpts
---@return boolean success
---@return string? error
function M.create_cycle_template(opts)
  -- Validate input
  if type(opts) ~= 'table' then
    return false, 'Invalid options'
  end
  if type(opts.cycle_name) ~= 'string' or opts.cycle_name == '' then
    return false, 'cycle_name is required'
  end

  local iterations = opts.iterations or 3
  local days_per_iteration = opts.days_per_iteration or 7
  local base_path = opts.path or config.exercises_path

  -- Create cycle directory
  local cycle_path = base_path .. '/cycles/' .. opts.cycle_name
  local ok, err = ensure_dir(cycle_path)
  if not ok then return false, err end

  -- Create metadata.yaml
  local metadata = generate_metadata(opts.cycle_name, iterations, days_per_iteration)
  ok, err = write_file(cycle_path .. '/metadata.yaml', metadata)
  if not ok then return false, err end

  -- Create iterations
  for iter = 1, iterations do
    local iter_path = string.format('%s/iteration_%d', cycle_path, iter)
    ok, err = ensure_dir(iter_path)
    if not ok then return false, err end

    -- Create days
    for day = 1, days_per_iteration do
      local day_path = string.format('%s/day_%02d', iter_path, day)
      ok, err = ensure_dir(day_path)
      if not ok then return false, err end

      -- Create exercises.yaml
      local exercises = generate_exercises(day)
      ok, err = write_file(day_path .. '/exercises.yaml', exercises)
      if not ok then return false, err end

      -- Create info files
      for _, suffix in ipairs({'a', 'b', 'c', 'd'}) do
        local info = generate_info(day, suffix)
        ok, err = write_file(day_path .. '/info_' .. suffix .. '.md', info)
        if not ok then return false, err end
      end
    end
  end

  -- Create references
  local refs_path = base_path .. '/references/commands'
  ok, err = ensure_dir(refs_path)
  if not ok then return false, err end

  for _, cmd in ipairs({'grep', 'find', 'sed', 'awk', 'echo'}) do
    local ref_file = refs_path .. '/' .. cmd .. '.md'
    if vim.fn.filereadable(ref_file) == 0 then
      local ref_content = generate_reference(cmd)
      ok, err = write_file(ref_file, ref_content)
      if not ok then return false, err end
    end
  end

  return true
end

return M
