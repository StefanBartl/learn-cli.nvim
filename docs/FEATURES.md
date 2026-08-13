# Features

`learn-cli.nvim` is a small dashboard-driven layer for working through
hand-authored CLI exercise cycles stored as YAML/Markdown on disk. This
covers what's actually wired up through `setup()` — the source tree also
contains a larger, unwired scoring/exercise-runner/validator subsystem
(`lua/learn_cli/core/`, `lua/learn_cli/data/persistence.lua`,
`lua/learn_cli/ui/exercise_view.lua`) that no command or keymap currently
reaches; see `docs/padagogical-concept.md` for where that's headed.

## Dashboard

A centered floating window (`:LearnCLIDashboard` or the `toggle_dashboard`
keymap) showing the active cycle's name/description/difficulty, a day
progress bar, the current exercise's title/command/description, and a
static keybindings cheat-sheet. `q` closes it; `n`/`p` step to the
next/previous exercise and refresh the view in place.

- **Module:** `ui/dashboard/init.lua` (`open`, `close`, `toggle`, `refresh`)
- **Usercmds:** `:LearnCLIDashboard`
- **Keymaps:** `toggle_dashboard` (default `<leader>ld`)
- **Config:** `opts.auto_open_dashboard` (default `false`) — opens the
  dashboard automatically ~100ms after `setup()`

## Exercise navigation

Steps `current_exercise` forward/backward within the loaded day's exercise
list, wrapping notifications ("Exercise 2/4", or "Last/First exercise of
the day" at the ends) and refreshing the dashboard if it's open.

- **Module:** `state/init.lua` (`next_exercise`, `prev_exercise`)
- **Usercmds:** `:LearnCLINext`, `:LearnCLIPrev`
- **Keymaps:** `next_exercise` (default `<leader>ln`), `prev_exercise`
  (default `<leader>lp`)

## Cycle info

Prints the active cycle's name, description, and current
day/iteration/exercise counters via `vim.notify`.

- **Module:** `user_actions/commands.lua`, `state/init.lua`
  (`get_cycle_info`, `get_progress`)
- **Usercmds:** `:LearnCLIInfo`

## Progress reset

Resets day/iteration/exercise counters back to the start of the current
cycle and reloads its exercise data, behind a yes/no confirmation dialog
(`lib.nvim.ui.kit.confirm`).

- **Module:** `state/init.lua` (`reset_progress`)
- **Usercmds:** `:LearnCLIReset`

## Cycle template scaffolding

Generates a complete cycle directory tree from scratch: `metadata.yaml`,
one `iteration_N/day_NN/` folder per iteration × day (default 3 × 7) each
with an `exercises.yaml` (two starter `grep`/`find` exercises) and four
`info_{a,b,c,d}.md` learning-material stubs, plus a shared
`references/commands/*.md` stub per built-in command (`grep`, `find`,
`sed`, `awk`, `echo`) if one doesn't already exist there.

- **Module:** `template_generator.lua` (`create_cycle_template`)
- **Usercmds:** `:LearnCLICreateCycle <cycle_name> [path]`

## Cycle/exercise data model

Exercises live under `opts.exercises_path/cycles/<cycle_name>/` as
`metadata.yaml` (name, description, iterations, days, difficulty) plus
per-day `exercises.yaml` files parsed by a minimal hand-rolled key-value
YAML reader (`state/init.lua`'s `parse_yaml_simple` — no nesting, no lists,
one `key: value` per line). Up to four `info_{a,b,c,d}.md` files per day
supply the reading material shown alongside the exercises.

- **Module:** `state/init.lua`, `config/init.lua`
  (`get_cycles_path`, `get_cycle_path`, `get_references_path`)
- **Config:** `opts.exercises_path` (default
  `vim.fn.stdpath("config") .. "/exercises"`) — `setup()` warns if this
  directory doesn't exist, but does not create it
