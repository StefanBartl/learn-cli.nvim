# Workflow — using learn-cli.nvim day to day

Every feature here is documented on its own in `docs/FEATURES.md`. This is
the different question: what a session with the plugin actually looks like,
given how small and disk-driven it currently is.

## There is no exercise content until you create it

`:LearnCLIDashboard` on a fresh install shows "No exercise loaded" — the
plugin ships no built-in cycle. The first real step is always
`:LearnCLICreateCycle cycle_01`, which scaffolds `metadata.yaml` plus a
full `iteration_N/day_NN/` tree under `opts.exercises_path` (default
`stdpath("config")/exercises`). Point `exercises_path` at a real directory
in your config *before* running `setup()`, or the scaffolding lands
somewhere you didn't intend and `state.init()` will keep warning that the
exercises path doesn't exist.

```lua
require('learn_cli').setup({
  exercises_path = vim.fn.stdpath("config") .. "/learn_cli_exercises",
})
```

```vim
:LearnCLICreateCycle cycle_01
```

Then edit the generated `exercises.yaml`/`info_*.md` files by hand — the
generator only ever fills in two placeholder exercises (`grep`, `find`) per
day as a starting skeleton, not real content.

## The YAML parser is intentionally naive — know its limits before authoring content

`state.lua`'s `parse_yaml_simple` is a one-line-at-a-time `key: value`
matcher, not a real YAML parser: no nested maps, no YAML lists (the
`hints:` block style you'll see in real YAML tooling won't parse here),
and quoted values only get their outer `"`/`'` stripped. Writing
multi-line hint text or nested structure into `exercises.yaml` by hand
will silently produce a exercise record missing those fields rather than
an error — check `:LearnCLIInfo` / the dashboard's exercise panel after
editing to confirm the fields you expect actually loaded.

## Dashboard `n`/`p` vs. `:LearnCLINext`/`:LearnCLIPrev` — same command, two entry points

The dashboard buffer maps `n`/`p` directly to the same
`:LearnCLINext`/`:LearnCLIPrev` commands the global keymaps
(`<leader>ln`/`<leader>lp` by default) run — there's no separate
in-dashboard state. Reach for the dashboard's own `n`/`p` while it's open
(no prefix, immediate) and the global leader keymaps when it's closed;
mixing them causes no harm, they mutate the same counters.

## `:LearnCLIReset` only rewinds position, it doesn't touch scoring

Because the scoring/persistence subsystem (`core/scorer.lua`,
`core/scoring.lua`, `data/persistence.lua`) isn't wired into `setup()`,
`:LearnCLIReset` — despite the confirmation prompt calling it "Reset all
progress" — only resets `current_day`/`current_iteration`/
`current_exercise` back to 1 and reloads that day's exercises. There is no
saved score, streak, or completion history in the live plugin to actually
lose; don't expect the confirmation dialog's phrasing to mean more than it
currently does.

## Multiple cycles: no `:Session`-style switcher

There is no `:LearnCLISetCycle` command exposed anywhere — `state.lua`
does expose `M.set_cycle(name)` at the Lua level, but nothing in
`user_actions/commands.lua` calls it. Switching cycles today means calling
`require('learn_cli.state').set_cycle("cycle_02")` yourself from a
keymap or `:lua`, after scaffolding it with `:LearnCLICreateCycle
cycle_02`.

## README vs. reality

The top-level `README.md` documents a considerably larger plugin —
`:LearnCliStart`, `:LearnCliStats`, `:LearnCliExport`/`Import`, a
terminal-integrated exercise view, spaced-repetition scheduling — none of
which exist in the current `lua/` tree under those names (the real
commands are `LearnCLIDashboard`/`Next`/`Prev`/`Info`/`Reset`/
`CreateCycle`). Treat the README's feature list and command table as the
design target described in `docs/padagogical-concept.md`, not as what
`require('learn_cli').setup()` gives you today; `docs/FEATURES.md` and this
file describe the plugin as it actually runs.
