# 🎓 learn-cli.nvim

An interactive learning platform for mastering CLI tools directly in Neovim. Practice commands with guided exercises, track your progress, and build muscle memory through spaced repetition.

## Table of content

  - [✨ Features](#features)
  - [📦 Installation](#installation)
    - [Using [lazy.nvim](https://github.com/folke/lazy.nvim)](#using-lazynvimhttpsgithubcomfolkelazynvim)
    - [Using [packer.nvim](https://github.com/wbthomason/packer.nvim)](#using-packernvimhttpsgithubcomwbthomasonpackernvim)
  - [🚀 Quick Start](#quick-start)
  - [⚙️ Configuration](#configuration)
    - [Default Configuration](#default-configuration)
  - [🎮 Usage](#usage)
    - [Commands](#commands)
    - [Default Keymaps](#default-keymaps)
  - [📚 Creating Custom Exercises](#creating-custom-exercises)
  - [🔄 Creating Cycles](#creating-cycles)
  - [📊 Scoring System](#scoring-system)
  - [🎯 Difficulty Progression](#difficulty-progression)
  - [🧠 Learning Principles](#learning-principles)
    - [Spaced Repetition](#spaced-repetition)
    - [Progressive Difficulty](#progressive-difficulty)
    - [Active Recall](#active-recall)
    - [Deliberate Practice](#deliberate-practice)
  - [🔍 Built-in Exercises](#built-in-exercises)
  - [🤝 Contributing](#contributing)
  - [📝 License](#license)
  - [🙏 Acknowledgments](#acknowledgments)
  - [📮 Support](#support)

---

## ✨ Features

- 🎯 **Structured Learning Paths**: Organized exercises in progressive cycles
- 📊 **Progress Tracking**: Detailed statistics, scores, and mastery levels
- ⏱️ **Adaptive Difficulty**: Target times adjust based on your performance
- 💡 **Progressive Hints**: Get help when stuck (with minimal score penalty)
- 🏆 **Score & Ranking**: Performance-based scoring with best time/score tracking
- 📁 **Exercise Files**: Practice with real files attached to each exercise
- 📚 **References**: Built-in documentation and learning resources
- 💾 **State Persistence**: Your progress is automatically saved
- 🔧 **Fully Customizable**: Add your own exercises, cycles, and configurations

## 📦 Installation

Requires [lib.nvim](https://github.com/StefanBartl/lib.nvim) — used for
notifications and state-file I/O.

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'StefanBartl/learn-cli.nvim',
  dependencies = { "StefanBartl/lib.nvim" },
  config = function()
    require('learn_cli').setup({
      -- Your configuration here
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'StefanBartl/learn-cli.nvim',
  requires = { "StefanBartl/lib.nvim" },
  config = function()
    require('learn_cli').setup()
  end
}
```

## 🚀 Quick Start

1. Install the plugin
2. Run `:LearnCli` to open the dashboard
3. Select a cycle or exercise to begin
4. Practice in the integrated terminal
5. Track your progress over time

## ⚙️ Configuration

### Default Configuration

```lua
require('learn_cli').setup({
  -- Data storage location
  data_dir = vim.fn.stdpath("data") .. "/learn_cli",

  -- Auto-save progress
  auto_save = true,
  auto_save_interval_ms = 30000, -- 30 seconds

  -- UI settings
  ui = {
    dashboard = {
      width = "85%",
      height = "85%",
      border = "rounded", -- "single", "double", "rounded", "none"
      show_stats = true,
      show_recent = true,
      recent_count = 10,
    },
    exercise_view = {
      width = "90%",
      height = "90%",
      border = "rounded",
      show_timer = true,
      show_hints_count = true,
      terminal_height = 15,
    },
    show_progress_bar = true,
    use_icons = true,
  },

  -- Scoring algorithm
  scoring = {
    base_score = 100,
    hint_penalty = 10,
    time_bonus_threshold = 0.8, -- Bonus if < 80% of target time
    time_penalty_threshold = 1.5, -- Penalty if > 150% of target time
    completion_bonus = 10,
  },

  -- Timer settings
  timer = {
    show_warnings = true,
    warning_at_percent = 0.75, -- Warn at 75% of target time
    adaptive_target = true, -- Adjust target based on performance
    adaptive_factor = 0.9, -- 10% adjustment
  },

  -- Keymaps
  keymaps = {
    prefix = "<leader>lc",
    dashboard = "d",
    next_exercise = "n",
    prev_exercise = "p",
    show_hint = "h",
    complete_exercise = "<CR>",
    quit = "q",
  },
})
```

## 🎮 Usage

### Commands

| Command | Description |
|---------|-------------|
| `:LearnCli` | Open the main dashboard |
| `:LearnCliStart <id>` | Start a specific exercise by ID |
| `:LearnCliStats` | Show detailed statistics |
| `:LearnCliExport <file>` | Export progress to a file |
| `:LearnCliImport <file>` | Import progress from a file |
| `:LearnCliBackup` | Create a backup of current progress |
| `:LearnCliReset!` | Reset all progress (with confirmation) |

### Default Keymaps

Global (configurable prefix: `<leader>lc`):

- `<leader>lcd` - Open dashboard
- `<leader>lcs` - Show statistics
- `<leader>lcb` - Backup progress

In Exercise View:

- `n` - Next exercise
- `p` - Previous exercise
- `h` - Show next hint
- `<CR>` - Mark exercise complete
- `q` - Quit exercise view

## 📚 Creating Custom Exercises

Create a Lua file in your exercises directory:

```lua
-- ~/.config/nvim/learn_cli_exercises/my_exercises.lua

return {
  {
    id = "sed_basic_replace",
    program = "sed",
    title = "Basic Text Replacement",
    description = "Learn to replace text using sed",
    difficulty = "beginner",
    target_time_seconds = 180,

    task = [[
You have a file 'data.txt' with various lines.

Task:
1. Replace all occurrences of "foo" with "bar"
2. Save the result to 'output.txt'

Expected command: sed 's/foo/bar/g' data.txt > output.txt
    ]],

    hints = {
      "Use sed with the 's' command for substitution",
      "The syntax is: s/pattern/replacement/flags",
      "The 'g' flag means 'global' (all occurrences)",
    },

    files = {
      ["data.txt"] = [[
foo is here
more foo there
foo foo everywhere
not here though
      ]],
    },

    references = {
      "man sed",
      "https://www.gnu.org/software/sed/manual/sed.html",
    },

    tags = { "sed", "text", "replace" },
    prerequisites = {},
  },
}
```

Then configure the exercises directory:

```lua
require('learn_cli').setup({
  exercises_dir = vim.fn.stdpath("config") .. "/learn_cli_exercises",
})
```

## 🔄 Creating Cycles

Cycles group related exercises into learning paths:

```lua
-- In your custom exercises file or separate cycle file

local cycles = {
  {
    id = "grep_fundamentals",
    name = "Grep Fundamentals",
    description = "Master the grep command",
    exercise_ids = {
      "grep_basic_search",
      "grep_case_insensitive",
      "grep_regex_basics",
      "grep_inverted_match",
    },
    estimated_duration_minutes = 20,
    difficulty = "beginner",
  },
}

-- Register cycles
for _, cycle in ipairs(cycles) do
  require('learn_cli.state').register_cycle(cycle)
end
```

## 📊 Scoring System

Your score for each exercise is calculated based on:

1. **Base Score**: 100 points (default)
2. **Hint Penalties**: -10 points per hint used
3. **Time Bonuses**: Up to +20 points for fast completion
4. **Time Penalties**: Up to -10 points for slow completion
5. **Completion Bonus**: +10 points for finishing

**Mastery Level** is calculated from your recent performance (last 5 attempts) and improves with:
- High scores
- Consistency (completing all recent attempts)
- Experience (total attempts)

## 🎯 Difficulty Progression

Exercises are tagged with difficulty levels:

- 🟢 **Beginner**: Basic commands and simple flags
- 🟡 **Intermediate**: Combined flags and pipes
- 🟠 **Advanced**: Complex scenarios and edge cases
- 🔴 **Expert**: Optimization and advanced patterns

The plugin suggests difficulty progression based on your mastery level:
- ≥80% mastery → Suggested to move up
- <40% mastery → Suggested to review easier exercises

## 🧠 Learning Principles

This plugin incorporates proven learning techniques:

### Spaced Repetition
- Revisit exercises after intervals
- Reinforces memory through practice
- Tracks time since last attempt

### Progressive Difficulty
- Start with basics, build to advanced
- Prerequisites ensure proper foundation
- Adaptive timing adjusts to your pace

### Active Recall
- Practice in real terminal environment
- No passive reading - hands-on learning
- Immediate feedback on attempts

### Deliberate Practice
- Focused exercises on specific skills
- Measurable progress tracking
- Challenging but achievable targets

## 🔍 Built-in Exercises

The plugin comes with exercises for:

- **grep**: Text search and pattern matching
- **sed**: Stream editing and text transformation
- *(More coming soon!)*

## 🤝 Contributing

Contributions are welcome! Please check out the [Developer README](docs/devs/DEV-README.md) for guidelines on:

- Adding new exercises
- Improving the scoring algorithm
- Extending the UI
- Writing tests

## 📝 License

MIT License - see [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Inspired by command-line learning tools and spaced repetition systems
- Built with Neovim's powerful Lua API
- Thanks to the Neovim community for feedback and contributions

## 📮 Support

- 🐛 [Report Issues](https://github.com/StefanBartl/learn-cli.nvim/issues)
- 💡 [Feature Requests](https://github.com/StefanBartl/learn-cli.nvim/issues)
- 📖 [Documentation](https://github.com/StefanBartl/learn-cli.nvim/wiki)

---

**Happy Learning! 🚀**
