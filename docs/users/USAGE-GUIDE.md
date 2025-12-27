# learn-cli.nvim

Interactive CLI command learning plugin for Neovim.

## Features

- 📚 Structured learning cycles with exercises
- 📈 Progress tracking through days and iterations
- 🎯 Exercise hints and solutions
- 📝 Integrated learning material
- ⚡ Template generator for new cycles
- 🎨 Clean dashboard interface

## Installation

### lazy.nvim

```lua
{
  'lavalue/learn-cli.nvim',
  config = function()
    require('learn_cli').setup({
      exercises_path = vim.fn.stdpath('config') .. '/exercises',
      auto_open_dashboard = false,
    })
  end
}
```

### packer.nvim

```lua
use {
  'lavalue/learn-cli.nvim',
  config = function()
    require('learn_cli').setup()
  end
}
```

## Quick Start

1. **Create your first cycle**:
   ```vim
   :LearnCLICreateCycle cycle_01
   ```

2. **Open the dashboard**:
   ```vim
   :LearnCLIDashboard
   ```
   Or use keymap: `<leader>ld`

3. **Navigate exercises**:
   - `n` - Next exercise
   - `p` - Previous exercise
   - `q` - Close dashboard

## Configuration

```lua
require('learn_cli').setup({
  -- Path to exercises directory
  exercises_path = vim.fn.stdpath('config') .. '/exercises',

  -- Auto-open dashboard on startup
  auto_open_dashboard = false,

  -- Notification level
  notify_level = vim.log.levels.INFO,

  -- Custom keymaps
  keymaps = {
    next_exercise = '<leader>ln',
    prev_exercise = '<leader>lp',
    toggle_dashboard = '<leader>ld',
  }
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:LearnCLIDashboard` | Toggle dashboard |
| `:LearnCLINext` | Next exercise |
| `:LearnCLIPrev` | Previous exercise |
| `:LearnCLIInfo` | Show cycle information |
| `:LearnCLIReset` | Reset progress (with confirmation) |
| `:LearnCLICreateCycle <name> [path]` | Create new cycle template |

## File Structure

When you create a cycle, this structure is generated:

```
exercises/
├── cycles/
│   └── cycle_01/
│       ├── metadata.yaml          # Cycle configuration
│       └── iteration_1/
│           ├── day_01/
│           │   ├── exercises.yaml # Daily exercises
│           │   ├── info_a.md      # Learning material
│           │   ├── info_b.md
│           │   ├── info_c.md
│           │   └── info_d.md
│           ├── day_02/
│           └── ... (up to day_07)
└── references/
    └── commands/
        ├── grep.md               # Command references
        ├── find.md
        ├── sed.md
        ├── awk.md
        └── echo.md
```

### metadata.yaml

```yaml
name: cycle_01
description: "CLI commands learning cycle"
iterations: 3
days: 7
difficulty: beginner
topics:
  - grep
  - find
  - sed
  - awk
```

### exercises.yaml

```yaml
exercises:
  - id: 1
    title: "Find Files by Name"
    difficulty: easy
    command: find
    description: "Use find to locate files"
    hints:
      - "Use -name for pattern matching"
    solution: "find . -name '*.txt'"
```

## Creating Custom Cycles

1. Use the template generator:
   ```vim
   :LearnCLICreateCycle my_cycle
   ```

2. Edit `metadata.yaml` to customize:
   - Number of iterations
   - Days per iteration
   - Topics covered

3. Customize exercises in `exercises.yaml` files

4. Write learning material in `info_*.md` files

5. Add command references in `references/commands/`

## Programmatic Usage

```lua
-- Get current progress
local progress = require('learn_cli').get_progress()
print(vim.inspect(progress))

-- Open dashboard
require('learn_cli').open_dashboard()

-- Create cycle
local ok, err = require('learn_cli').create_cycle('cycle_02')
```

## Troubleshooting

### Cycle not found

**Error**: `Cycle not found: cycle_01`

**Solution**: Create the cycle first:
```vim
:LearnCLICreateCycle cycle_01
```

### Custom exercises path

If exercises are in a different location:

```lua
require('learn_cli').setup({
  exercises_path = '/path/to/your/exercises'
})
```

## License

MIT License - see [LICENSE](LICENSE) file

## Contributing

Contributions welcome! Please check existing issues or create new ones.

## Roadmap

- [ ] Progress persistence to file
- [ ] Multiple cycle support in UI
- [ ] Exercise validation and testing
- [ ] Export/import cycles
- [ ] Colorscheme customization
- [ ] Exercise search and filtering
