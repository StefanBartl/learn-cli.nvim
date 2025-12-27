---@brief Plugin entry point for learn_cli.nvim
---@description
--- This file is automatically sourced by Neovim when the plugin loads.
--- It sets up global state and prevents double-loading.

-- Prevent double loading
if vim.g.loaded_learn_cli then
  return
end
vim.g.loaded_learn_cli = 1

-- Plugin is loaded via require('learn_cli').setup()
-- No automatic initialization here to allow user configuration
