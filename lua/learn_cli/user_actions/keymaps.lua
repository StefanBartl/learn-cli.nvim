---@module 'learn_cli.user_actions.keymaps'
---@brief Keymap configuration for learn-cli.nvim
---@description
--- Sets up global keymaps based on user configuration.
--- Uses the configured prefix and individual key bindings.

local config = require("learn_cli.config")

local M = {}

---Setup global keymaps
---@return nil
function M.setup()
  local keymap_config = config.get("keymaps")
  local prefix = keymap_config.prefix

  -- Helper to create prefixed keymaps
  local function map(key, cmd, desc)
    local full_key = prefix .. key
    vim.keymap.set("n", full_key, cmd, {
      desc = "Learn CLI: " .. desc,
      silent = true,
    })
  end

  -- Dashboard
  map(keymap_config.dashboard, function()
    require("learn_cli").open_dashboard()
  end, "Open dashboard")

  -- Quick stats (without opening dashboard)
  map("s", function()
    vim.cmd("LearnCliStats")
  end, "Show statistics")

  -- Backup progress
  map("b", function()
    vim.cmd("LearnCliBackup")
  end, "Backup progress")

  -- In exercise view (these are set up when exercise view is opened)
  -- But we define the actions here for consistency

  M.exercise_actions = {
    next = function()
      -- TODO: Navigate to next exercise
      vim.notify("Next exercise", vim.log.levels.INFO)
    end,

    prev = function()
      -- TODO: Navigate to previous exercise
      vim.notify("Previous exercise", vim.log.levels.INFO)
    end,

    hint = function()
      -- TODO: Show next hint
      vim.notify("Hint revealed", vim.log.levels.INFO)
    end,

    complete = function()
      -- TODO: Mark exercise complete
      vim.notify("Exercise completed", vim.log.levels.INFO)
    end,

    quit = function()
      -- TODO: Close exercise view
      vim.notify("Quitting exercise", vim.log.levels.INFO)
    end,
  }
end

--- Setup Exercise Keymaps
---@param state table ExerciseState
---@diagnostic disable-next-line: unused-local
function M.setup_exercise_keymaps(state)
  -- Diese Keymaps sind global während ein Exercise aktiv ist

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
      desc = "LearnCli: " .. desc,
    })
  end

  -- Submit
  map("n", "<leader>ls", ":LearnCliSubmit<CR>", "Submit solution")

  -- Hint
  map("n", "<leader>lh", ":LearnCliHint<CR>", "Show next hint")

  -- Solution
  map("n", "<leader>lS", ":LearnCliSolution<CR>", "Show solution")

  -- Quit
  map("n", "<leader>lq", ":LearnCliQuit<CR>", "Quit exercise")

  -- Refresh Exercise View
  map("n", "<leader>lr", function()
    require("learn_cli.ui.exercise_view").render()
  end, "Refresh exercise view")
end

--- Cleanup Exercise Keymaps
function M.cleanup_exercise_keymaps()
  -- Remove global keymaps
  pcall(vim.keymap.del, "n", "<leader>ls")
  pcall(vim.keymap.del, "n", "<leader>lh")
  pcall(vim.keymap.del, "n", "<leader>lS")
  pcall(vim.keymap.del, "n", "<leader>lq")
  pcall(vim.keymap.del, "n", "<leader>lr")
end

return M
