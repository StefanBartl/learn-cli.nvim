# 🛠️ Developer Guide - learn-cli.nvim

This document provides detailed information about the plugin's architecture, development guidelines, and how to extend functionality.

## Table of content

  - [📐 Architecture Overview](#architecture-overview)
    - [Directory Structure](#directory-structure)
    - [Core Principles](#core-principles)
      - [1. Safety & Error Handling](#1-safety-error-handling)
      - [2. Modularity](#2-modularity)
      - [3. State Management](#3-state-management)
      - [4. Performance](#4-performance)
  - [🔧 Development Setup](#development-setup)
    - [Prerequisites](#prerequisites)
    - [Local Development](#local-development)
  - [📝 Code Style & Guidelines](#code-style-guidelines)
    - [Annotations](#annotations)
    - [Error Handling Pattern](#error-handling-pattern)
    - [Window/Buffer Management](#windowbuffer-management)
    - [Import Order](#import-order)
  - [🏗️ Adding New Features](#adding-new-features)
    - [Adding a New Exercise](#adding-a-new-exercise)
    - [Adding a New UI Component](#adding-a-new-ui-component)
    - [Extending the Scoring System](#extending-the-scoring-system)
  - [🧪 Testing](#testing)
    - [Manual Testing](#manual-testing)
    - [Unit Testing (Future)](#unit-testing-future)
  - [📊 State Schema](#state-schema)
    - [Exercise Progress Structure](#exercise-progress-structure)
    - [Complete State Structure](#complete-state-structure)
  - [🔍 Performance Considerations](#performance-considerations)
    - [String Operations](#string-operations)
    - [Table Operations](#table-operations)
    - [Async Operations](#async-operations)
  - [📚 Resources](#resources)
  - [🤝 Contributing](#contributing)
  - [📝 Changelog](#changelog)
  - [📮 Questions?](#questions)

---

## 📐 Architecture Overview

### Directory Structure

```
learn-cli.nvim/
├── lua/learn_cli/
│   ├── @types/           # Type definitions (for LSP)
│   │   └── init.lua
│   ├── config/           # Configuration management
│   │   ├── defaults.lua  # Default configuration values
│   │   └── init.lua      # Config manager with validation
│   ├── core/             # Core business logic
│   │   ├── exercise.lua  # Exercise execution engine
│   │   ├── cycle.lua     # Cycle management
│   │   ├── scoring.lua   # Score calculation algorithms
│   │   └── timer.lua     # Time tracking and warnings
│   ├── data/             # Data layer
│   │   ├── persistence.lua  # Save/load state
│   │   └── exercises/       # Exercise definitions
│   │       ├── grep.lua
│   │       ├── sed.lua
│   │       └── ...
│   ├── state/            # State management
│   │   └── init.lua      # Centralized state with getters/setters
│   ├── ui/               # User interface components
│   │   ├── dashboard/
│   │   │   └── init.lua  # Main dashboard UI
│   │   ├── exercise_view/
│   │   │   └── init.lua  # Exercise interaction UI
│   │   └── common/
│   │       └── init.lua  # Shared UI utilities
│   ├── user_actions/     # User-facing actions
│   │   ├── commands.lua  # Ex commands
│   │   └── keymaps.lua   # Keymap setup
│   └── init.lua          # Main plugin entry point
├── plugin/
│   └── learn_cli.lua     # Plugin bootstrap
├── doc/
│   └── learn_cli.nvim.txt # Vim help documentation
└── docs/
    └── devs/
        ├── DEV-README.md # This file
        └── CHANGELOG.md  # Version history
```

### Core Principles

Following the architecture guidelines from `Arch&Coding-Regeln.md`:

#### 1. Safety & Error Handling
- All critical operations wrapped in `pcall()`
- Type guards before API access (`type()`, `nil` checks)
- Buffer/Window validation with `nvim_*_is_valid()`
- Structured error types (`OperationResult`, `ValidationResult`)
- No silent failures - explicit `ok/error` returns

#### 2. Modularity
- **Single Responsibility**: Each module has one clear purpose
- **No Global State**: All state via getter/setter in `state` module
- **Pure Functions**: Core logic has no side effects
- **Dependency Injection**: Dependencies passed explicitly

#### 3. State Management
- Centralized in `state/init.lua`
- Getter/Setter pattern prevents direct access
- Snapshot/Restore for testing and undo
- UI state separate from data state

#### 4. Performance
- Tables pre-allocated when size known
- `table.concat` for string building (never `..` in loops)
- Async operations for background tasks
- Weak tables for caches (`__mode = "v"`)
- Debounced writes to disk

## 🔧 Development Setup

### Prerequisites

- Neovim 0.9.0+
- Lua 5.1 or LuaJIT
- Git

### Local Development

1. Clone the repository:
```bash
git clone https://github.com/StefanBartl/learn-cli.nvim.git
cd learn-cli.nvim
```

2. Link for development:
```bash
# Create symlink in your Neovim config
ln -s $(pwd) ~/.local/share/nvim/site/pack/dev/start/learn-cli.nvim
```

3. Configure Lua Language Server (optional but recommended):

Create `.luarc.json` in project root:

```json
{
  "runtime": {
    "version": "LuaJIT"
  },
  "diagnostics": {
    "globals": ["vim"]
  },
  "workspace": {
    "library": [
      "${3rd}/luv/library",
      "${3rd}/busted/library",
      "~/.local/share/nvim/runtime"
    ],
    "checkThirdParty": false
  },
  "telemetry": {
    "enable": false
  }
}
```

## 📝 Code Style & Guidelines

### Annotations

Every file must start with module documentation:

```lua
---@module 'learn_cli.module_name'
---@brief Short description
---@description
--- Detailed multi-line description of what this module does,
--- its responsibilities, and any important notes.
```

Every public function must be documented:

```lua
---Short description of function
---@param param_name type Description of parameter
---@param optional_param type|nil Optional parameter description
---@return return_type description Description of return value
---@return error_type|nil error_description Error if operation fails
function M.my_function(param_name, optional_param)
  -- Implementation
end
```

### Error Handling Pattern

All operations return `OperationResult`:

```lua
function M.risky_operation()
  local ok, result = pcall(function()
    -- Validate inputs
    if not valid then
      return {
        ok = false,
        error = "Detailed error message",
        data = nil
      }
    end

    -- Do work
    local output = do_something()

    return {
      ok = true,
      error = nil,
      data = output
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Operation failed: " .. tostring(result),
      data = nil
    }
  end

  return result
end
```

### Window/Buffer Management

Always validate handles:

```lua
local win = state.get_some_win()

-- Check validity before use
if not state.is_win_valid(win) then
  return { ok = false, error = "Window is not valid", data = nil }
end

-- Safe to use
vim.api.nvim_win_set_option(win, "cursorline", true)
```

### Import Order

Follow this order in every file:

1. System/Core modules (`vim`, `uv`)
2. Config and utility modules
3. State modules
4. UI components
5. Controllers and logic

```lua
-- System
local vim = vim

-- Config/Utils
local config = require("learn_cli.config")

-- State
local state = require("learn_cli.state")

-- UI
local dashboard = require("learn_cli.ui.dashboard")

-- Logic
local scoring = require("learn_cli.core.scoring")
```

## 🏗️ Adding New Features

### Adding a New Exercise

Create a file in `lua/learn_cli/data/exercises/`:

```lua
---@module 'learn_cli.data.exercises.mycommand'

---@type Exercise[]
local exercises = {
  {
    id = "mycommand_basic",
    program = "mycommand",
    title = "Basic Usage",
    description = "Learn basic mycommand usage",
    difficulty = "beginner",
    target_time_seconds = 120,

    task = [[
Task description here...
    ]],

    hints = {
      "First hint",
      "Second hint",
    },

    files = {
      ["test.txt"] = "File content here",
    },

    references = {
      "man mycommand",
    },

    tags = { "mycommand", "beginner" },
    prerequisites = {},
  },
}

return exercises
```

Load it in `init.lua`:

```lua
local ok, mycommand_exercises = pcall(require, "learn_cli.data.exercises.mycommand")
if ok and mycommand_exercises then
  for _, exercise in ipairs(mycommand_exercises) do
    state.register_exercise(exercise)
  end
end
```

### Adding a New UI Component

1. Create module in `ui/` directory
2. Follow window creation pattern:

```lua
---@module 'learn_cli.ui.mycomponent'

local M = {}

---Create and show the component
---@return OperationResult result
function M.open()
  local ok, result = pcall(function()
    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Create window
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = 80,
      height = 24,
      row = 2,
      col = 2,
      style = "minimal",
      border = "rounded",
    })

    -- Validate
    if not vim.api.nvim_buf_is_valid(buf) then
      return { ok = false, error = "Failed to create buffer", data = nil }
    end

    -- Store in state
    -- Setup content and keymaps

    return {
      ok = true,
      error = nil,
      data = { buf = buf, win = win }
    }
  end)

  if not ok then
    return {
      ok = false,
      error = "Failed to open: " .. tostring(result),
      data = nil
    }
  end

  return result
end

return M
```

### Extending the Scoring System

Modify `core/scoring.lua` to add new scoring factors:

```lua
---Calculate score with new factors
---@param exercise Exercise
---@param duration_seconds number
---@param hints_used number
---@param completed boolean
---@param custom_metrics table|nil Additional metrics
---@return number score Final score
function M.calculate_score(exercise, duration_seconds, hints_used, completed, custom_metrics)
  -- Existing score calculation
  local score = scoring_config.base_score

  -- Add your custom scoring logic
  if custom_metrics and custom_metrics.accuracy then
    local accuracy_bonus = math.floor(custom_metrics.accuracy * 10)
    score = score + accuracy_bonus
  end

  return score
end
```

## 🧪 Testing

### Manual Testing

Use `:checkhealth learn_cli` to verify installation:

```vim
:checkhealth learn_cli
```

### Unit Testing (Future)

We plan to add:
- `plenary.nvim` test harness
- Property-based tests for scoring
- State management tests
- UI component tests

## 📊 State Schema

### Exercise Progress Structure

```lua
{
  exercise_id = "grep_basic",
  status = "completed", -- or "not_started", "in_progress", "mastered"
  attempts = {
    {
      exercise_id = "grep_basic",
      timestamp = 1234567890,
      duration_seconds = 145,
      hints_used = 1,
      completed = true,
      score = 85,
    },
  },
  best_score = 90,
  best_time = 120,
  total_attempts = 5,
  last_attempt_timestamp = 1234567890,
  mastery_level = 75,
}
```

### Complete State Structure

```lua
{
  exercises = {
    ["exercise_id"] = Exercise,
  },
  cycles = {
    ["cycle_id"] = Cycle,
  },
  progress = {
    ["exercise_id"] = ExerciseProgress,
  },
  cycle_progress = {
    ["cycle_id"] = CycleProgress,
  },
  current_exercise_id = "grep_basic",
  current_cycle_id = "grep_fundamentals",
  session_start = 1234567890,
  total_practice_time = 3600,
}
```

## 🔍 Performance Considerations

### String Operations

```lua
-- ❌ Bad: String concatenation in loop
local result = ""
for i = 1, 1000 do
  result = result .. tostring(i)
end

-- ✅ Good: Use table.concat
local parts = {}
for i = 1, 1000 do
  parts[i] = tostring(i)
end
local result = table.concat(parts)
```

### Table Operations

```lua
-- ❌ Bad: Growing table without pre-allocation
local t = {}
for i = 1, 1000 do
  table.insert(t, i)
end

-- ✅ Good: Pre-allocate space
local t = { [1000] = 0 } -- Reserve space
for i = 1, 1000 do
  t[i] = i
end
```

### Async Operations

```lua
-- Use vim.loop for background work
vim.loop.new_timer():start(0, 1000, vim.schedule_wrap(function()
  -- This runs async without blocking UI
  do_background_work()
end))
```

## 📚 Resources

- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Lua Performance Tips](http://www.lua.org/gems/sample.pdf)
- [Neovim API Documentation](https://neovim.io/doc/user/api.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow code style guidelines
4. Add tests (when framework is ready)
5. Update documentation
6. Submit pull request

## 📝 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

## 📮 Questions?

Open an issue or discussion on GitHub!
