---@module 'learn_cli.ui.exercise_view'
---@brief Zeigt Exercise während Ausführung

local M = {}

M.buf = nil
M.win = nil
M.state = nil

--- Zeigt Exercise an
---@param state table ExerciseState
function M.show(state)
  M.state = state

  -- Erstelle Buffer
  M.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = M.buf })
  vim.api.nvim_set_option_value("filetype", "learn-cli-exercise", { buf = M.buf })

  -- Erstelle Fenster (rechts)
  local width = math.floor(vim.o.columns * 0.4)
  local height = vim.o.lines - 4

  M.win = vim.api.nvim_open_win(M.buf, false, {
    relative = "editor",
    width = width,
    height = height,
    col = vim.o.columns - width,
    row = 1,
    style = "minimal",
    border = "rounded",
    title = " Exercise ",
    title_pos = "center",
  })

  -- Rendere Inhalt
  M.render()

  -- Keymaps
  M.setup_keymaps()
end

--- Rendert Exercise-Informationen
function M.render()
  if not M.state then
    return
  end

  local lines = {}
  local ex = M.state.exercise

  -- Header
  table.insert(lines, "")
  table.insert(lines, "  " .. ex.title)
  table.insert(lines, "")
  table.insert(lines, "  " .. string.rep("─", 50))
  table.insert(lines, "")

  -- Info
  table.insert(lines, string.format("  📊 Difficulty: %d/10", ex.difficulty))
  table.insert(lines, string.format("  🎯 Max Points: %d", ex.points_max))
  table.insert(lines, string.format("  ⏱️  Duration: %s", ex.duration))
  table.insert(lines, "")
  table.insert(lines, "  " .. string.rep("─", 50))
  table.insert(lines, "")

  -- Task
  table.insert(lines, "  📝 Task:")
  table.insert(lines, "")
  for line in ex.task.description:gmatch("[^\n]+") do
    table.insert(lines, "  " .. line)
  end
  table.insert(lines, "")

  if ex.task.expected_result then
    table.insert(lines, "  ✅ Expected Result:")
    table.insert(lines, "")
    for line in ex.task.expected_result:gmatch("[^\n]+") do
      table.insert(lines, "  " .. line)
    end
    table.insert(lines, "")
  end

  table.insert(lines, "  " .. string.rep("─", 50))
  table.insert(lines, "")

  -- Status
  local duration = os.time() - M.state.start_time
  table.insert(lines, string.format("  ⏱️  Time: %dm %ds", math.floor(duration / 60), duration % 60))
  table.insert(lines, string.format("  🔄 Attempts: %d", M.state.attempts))
  table.insert(lines, string.format("  💡 Hints used: %d", #M.state.hints_used))
  table.insert(lines, "")
  table.insert(lines, "  " .. string.rep("─", 50))
  table.insert(lines, "")

  -- Hints available
  if ex.hints and #ex.hints > 0 then
    table.insert(lines, string.format("  💡 Hints available: %d", #ex.hints))
    table.insert(lines, "")
  end

  -- Commands
  table.insert(lines, "  Commands:")
  table.insert(lines, "  • <leader>ls - Submit solution")
  table.insert(lines, "  • <leader>lh - Show hint")
  table.insert(lines, "  • <leader>lS - Show solution")
  table.insert(lines, "  • <leader>lq - Quit exercise")
  table.insert(lines, "")

  -- Working Directory
  table.insert(lines, "  📁 Working Directory:")
  table.insert(lines, "  " .. M.state.working_dir)
  table.insert(lines, "")

  -- In Buffer schreiben
  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })
end

--- Setup Keymaps
function M.setup_keymaps()
  if not M.buf then
    return
  end

  local opts = {buffer = M.buf, noremap = true, silent = true}

  -- Refresh
  vim.keymap.set("n", "r", function()
    M.render()
  end, opts)
end

--- Zeigt Errors
---@param state table
---@param errors string[]
---@diagnostic disable-next-line: unused-local
function M.show_errors(state, errors)
  local lines = {"", "  ❌ ERRORS:", ""}

  for _, err in ipairs(errors) do
    table.insert(lines, "  " .. err)
  end

  table.insert(lines, "")
  table.insert(lines, "  💡 Try again or use a hint!")
  table.insert(lines, "")

  -- Append to buffer
  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })
end

--- Zeigt Success
---@param state table
---@param score table
---@diagnostic disable-next-line: unused-local
function M.show_success(state, score)
  local lines = {
    "",
    "  " .. string.rep("═", 50),
    "  ✅ SUCCESS!",
    "  " .. string.rep("═", 50),
    "",
    string.format("  🎯 Score: %d/%d (%.0f%%)", score.total, score.max, score.percentage),
    string.format("  ⏱️  Time: %dm %ds", math.floor(score.duration / 60), score.duration % 60),
    string.format("  🔄 Attempts: %d", score.attempts),
    "",
  }

  if score.time_bonus > 0 then
    table.insert(lines, string.format("  ⚡ Time Bonus: +%d", score.time_bonus))
  end

  if score.hint_penalty > 0 then
    table.insert(lines, string.format("  💡 Hint Penalty: -%d", score.hint_penalty))
  end

  if score.solution_penalty > 0 then
    table.insert(lines, string.format("  🔑 Solution Penalty: -%d", score.solution_penalty))
  end

  table.insert(lines, "")
  table.insert(lines, "  Press any key to continue...")
  table.insert(lines, "")

  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })
end

--- Zeigt Hint
---@param state table
---@param hint table
---@diagnostic disable-next-line: unused-local
function M.show_hint(state, hint)
  local lines = {
    "",
    "  " .. string.rep("─", 50),
    string.format("  💡 Hint Level %d (Cost: %d points)",
      hint.level or 1, hint.cost or 10),
    "  " .. string.rep("─", 50),
    "",
  }

  for line in hint.text:gmatch("[^\n]+") do
    table.insert(lines, "  " .. line)
  end

  table.insert(lines, "")

  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })
end

--- Zeigt Solution
---@param state table
function M.show_solution(state)
  local ex = state.exercise
  local lines = {
    "",
    "  " .. string.rep("═", 50),
    "  🔑 SOLUTION",
    "  " .. string.rep("═", 50),
    "",
  }

  if ex.solution.primary then
    for line in ex.solution.primary:gmatch("[^\n]+") do
      table.insert(lines, "  " .. line)
    end
  end

  table.insert(lines, "")

  if ex.solution.alternatives then
    table.insert(lines, "  Alternative solutions:")
    table.insert(lines, "")
    for i, alt in ipairs(ex.solution.alternatives) do
      table.insert(lines, string.format("  %d. %s", i, alt))
    end
    table.insert(lines, "")
  end

  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, -1, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })
end

--- Schließt Exercise View
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
  M.buf = nil
  M.state = nil
end

return M
