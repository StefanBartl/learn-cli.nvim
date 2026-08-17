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
2. Create your first cycle: `:LearnCLICreateCycle cycle_01`
3. Run `:LearnCLIDashboard` to open the dashboard
4. Navigate exercises with `:LearnCLINext` / `:LearnCLIPrev`
5. Track your progress over time (see the full [Usage Guide](docs/users/USAGE-GUIDE.md))

## ⚙️ Configuration

### Default Configuration

```lua
require('learn_cli').setup({
  -- Path to your exercises/cycles directory
  exercises_path = vim.fn.stdpath('config') .. '/exercises',

  -- Auto-open dashboard on startup
  auto_open_dashboard = false,

  -- Notification level
  notify_level = vim.log.levels.INFO,

  -- Keymaps
  keymaps = {
    next_exercise = '<leader>ln',
    prev_exercise = '<leader>lp',
    toggle_dashboard = '<leader>ld',
  },
})
```

## 🎮 Usage

### Commands

| Command | Description |
|---------|-------------|
| `:LearnCLIDashboard` | Toggle the dashboard |
| `:LearnCLINext` | Move to the next exercise |
| `:LearnCLIPrev` | Move to the previous exercise |
| `:LearnCLIInfo` | Show current cycle information |
| `:LearnCLIReset` | Reset all progress (requires confirmation) |
| `:LearnCLICreateCycle <name> [path]` | Generate a new cycle template with full directory structure |

See the [Usage Guide](docs/users/USAGE-GUIDE.md) for the generated file structure and programmatic API (`get_progress()`, `open_dashboard()`, `create_cycle()`).

### Default Keymaps

- `<leader>ld` - Toggle dashboard
- `<leader>ln` - Next exercise
- `<leader>lp` - Previous exercise

All three are configurable via `keymaps` in `setup()`.

## 📚 Creating Custom Exercises

Exercises live as YAML files inside a cycle's day folder (`exercises_path/cycles/<cycle>/iteration_N/day_NN/exercises.yaml`):

```yaml
# Day 1 Exercises
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
```

Learning material for a day goes into `info_a.md` through `info_d.md` in the same folder, and command references into `references/commands/<command>.md`.

## 🔄 Creating Cycles

Use the built-in template generator to scaffold a new cycle's full directory structure (metadata, iterations, days, exercise YAML, info files, and command references):

```vim
:LearnCLICreateCycle my_cycle [path]
```

Or programmatically:

```lua
local ok, err = require('learn_cli').create_cycle('my_cycle')
```

Then edit the generated `metadata.yaml` (name, description, iterations, days, topics) and `exercises.yaml` files to customize the cycle. See the [Usage Guide](docs/users/USAGE-GUIDE.md) for the full generated file layout.

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
