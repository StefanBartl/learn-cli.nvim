---@module 'learn_cli.user_actions.keymaps'
---@brief Keymap setup for learn_cli.nvim

local M = {}

--- Setup keymaps from config
---@param keymaps table<string, string>
---@return nil
function M.setup(keymaps)
  if type(keymaps) ~= 'table' then
    return
  end

  local opts = { noremap = true, silent = true }

  -- Toggle dashboard
  if keymaps.toggle_dashboard then
    vim.keymap.set('n', keymaps.toggle_dashboard, function()
      require('learn_cli.ui.dashboard').toggle()
    end, vim.tbl_extend('force', opts, { desc = 'Toggle Learn CLI dashboard' }))
  end

  -- Next exercise
  if keymaps.next_exercise then
    vim.keymap.set('n', keymaps.next_exercise, function()
      vim.cmd('LearnCLINext')
    end, vim.tbl_extend('force', opts, { desc = 'Next exercise' }))
  end

  -- Previous exercise
  if keymaps.prev_exercise then
    vim.keymap.set('n', keymaps.prev_exercise, function()
      vim.cmd('LearnCLIPrev')
    end, vim.tbl_extend('force', opts, { desc = 'Previous exercise' }))
  end
end

return M
