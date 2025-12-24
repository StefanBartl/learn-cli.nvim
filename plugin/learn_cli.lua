---@brief Bootstrap file for learn-cli.nvim
---@description
--- This file is automatically sourced by Neovim on startup.
--- It sets up the plugin without executing heavy initialization
--- until the user actually needs it (lazy loading principle).

-- Prevent loading twice
if vim.g.loaded_learn_cli then
  return
end
vim.g.loaded_learn_cli = 1

-- Check Neovim version
local min_version = "0.9.0"
if vim.fn.has("nvim-" .. min_version) ~= 1 then
  vim.notify(
    string.format(
      "learn-cli.nvim requires Neovim %s or higher. Please upgrade.",
      min_version
    ),
    vim.log.levels.ERROR
  )
  return
end

