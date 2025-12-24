---@module 'learn_cli.ui.dashboard'
---@brief Main dashboard UI for learn-cli.nvim
---@description
--- Displays overview of available exercises, cycles, progress statistics,
--- and recent activity. Entry point for starting new exercises.

local M = {}

local notify = require("learn_cli.utils.notify")

M.buf = nil
M.win = nil

--- Zeigt M.Dashboard an
function M.show()
  -- Erstelle Buffer
  M.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = M.buf })
  vim.api.nvim_set_option_value("filetype", "learn-cli-dashboard", { buf = M.buf })

  -- Erstelle Fenster (zentriert)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  M.win = vim.api.nvim_open_win(M.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Learn CLI ",
    title_pos = "center",
  })

  -- Rendere Inhalt
  M.render()

  -- Keymaps
  M.setup_keymaps()
end

--- Rendert M.Dashboard-Inhalt
function M.render()
  local lines = {}

  -- Header
  table.insert(lines, "")
  table.insert(lines, "  🚀 Learn CLI - Interactive Command Line Training")
  table.insert(lines, "")
  table.insert(lines, "  ────────────────────────────────────────────────")
  table.insert(lines, "")

  -- Statistics
  local stats = require("learn_cli.state.progress").get_statistics()
  local level, xp = require("learn_cli.state.progress").get_level()

  table.insert(lines, string.format("  📊 Statistics"))
  table.insert(lines, string.format("     Level: %d | XP: %d", level, xp))
  table.insert(lines, string.format("     Exercises: %d | Perfect: %d",
    stats.exercises_completed, stats.perfect_scores))
  table.insert(lines, string.format("     Streak: %d days | Total Time: %d min",
    stats.streak, math.floor(stats.total_time / 60)))
  table.insert(lines, "")
  table.insert(lines, "  ────────────────────────────────────────────────")
  table.insert(lines, "")

  -- Cycles
  table.insert(lines, "  📚 Available Cycles")
  table.insert(lines, "")

  local cycle_manager = require("learn_cli.core.cycle_manager")
  local cycle_ids = cycle_manager.list_cycle_ids()

  if #cycle_ids == 0 then
    table.insert(lines, "  ⚠️  No cycles found!")
    table.insert(lines, "")
    table.insert(lines, "  Create cycles in: ~/.config/nvim/exercises/cycles/")
  else
    for i, cycle_id in ipairs(cycle_ids) do
      local info = cycle_manager.get_cycle_info(cycle_id)
      if info then
        local progress = require("learn_cli.state.progress").get_cycle_progress(cycle_id)

        local status_icon = progress.completed and "✅" or "📝"
        local progress_str = string.format("%d/%d days",
          progress.current_day - 1, info.days)

        table.insert(lines, string.format("  [%d] %s %s", i, status_icon, info.title))
        table.insert(lines, string.format("      Category: %s | Progress: %s",
          info.category, progress_str))
        table.insert(lines, "")
      end
    end
  end

  table.insert(lines, "")
  table.insert(lines, "  ────────────────────────────────────────────────")
  table.insert(lines, "")
  table.insert(lines, "  Press <Enter> to start | <q> to quit")
  table.insert(lines, "")

  -- In Buffer schreiben
  vim.api.nvim_set_option_value("modifiable", true, { buf = M.buf })
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })

  -- Speichere Cycle-IDs für Keymaps
  M.cycle_ids = cycle_ids
end

--- Setup Keymaps
function M.setup_keymaps()
  local opts = {buffer = M.buf, noremap = true, silent = true}

  -- Quit
  vim.keymap.set("n", "q", function()
    M.close()
  end, opts)

  vim.keymap.set("n", "<Esc>", function()
    M.close()
  end, opts)

  -- Start Cycle
  vim.keymap.set("n", "<CR>", function()
    M.select_cycle_under_cursor()
  end, opts)

  -- Number keys (1-9)
  for i = 1, 9 do
    vim.keymap.set("n", tostring(i), function()
      M.start_cycle(i)
    end, opts)
  end

  -- Refresh
  vim.keymap.set("n", "r", function()
    M.render()
  end, opts)
end

--- Wählt Cycle unter Cursor
function M.select_cycle_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local num = tonumber(line:match("^%s*%[(%d+)%]"))

  if num then
    M.start_cycle(num)
  else
    notify.warn("Kein Cycle unter Cursor")
  end
end

--- Startet einen Cycle
---@param index integer
function M.start_cycle(index)
  if not M.cycle_ids or #M.cycle_ids < index then
    notify.error("Cycle nicht gefunden")
    return
  end

  local cycle_id = M.cycle_ids[index]

  -- M.Dashboard schließen
  M.close()

  -- Cycle starten
  require("learn_cli").start_cycle(cycle_id)
end

--- Schließt M.Dashboard
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
  M.buf = nil
end

return M
