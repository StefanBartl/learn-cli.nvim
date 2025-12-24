---@module 'learn_cli.config.defaults'
---@brief Default configuration values for learn-cli.nvim
---@description
--- Provides sensible defaults for all configuration options.
--- Users can override these via setup({ ... }).

local M = {}

---@type LearnCLI.Config
M.defaults = {
  data_dir = vim.fn.stdpath("data") .. "/learn_cli",
  cache_dir = nil, -- Will default to data_dir/cache if not set
  exercises_dir = nil, -- Will default to plugin exercises if not set
  auto_save = true,
  auto_save_interval_ms = 30000, -- 30 seconds

  ui = {
    dashboard = {
      width = "85%",
      height = "85%",
      border = "rounded",
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

  scoring = {
    base_score = 100,
    hint_penalty = 10,
    time_bonus_threshold = 0.8, -- Complete in <80% of target time
    time_penalty_threshold = 1.5, -- Complete in >150% of target time
    completion_bonus = 10,
  },

  timer = {
    show_warnings = true,
    warning_at_percent = 0.75, -- Warn at 75% of target time
    adaptive_target = true,
    adaptive_factor = 0.9, -- Adjust target by 10% based on performance
  },

  keymaps = {
    prefix = "<leader>lc",
    dashboard = "d",
    next_exercise = "n",
    prev_exercise = "p",
    show_hint = "h",
    complete_exercise = "<CR>",
    quit = "q",
  },
}

return M
