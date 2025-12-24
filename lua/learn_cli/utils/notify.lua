---@module 'learn_cli.utils.notify'
---@brief Notification helper

local M = {}

function M.info(msg)
  vim.notify(msg, vim.log.levels.INFO, {title = "Learn CLI"})
end

function M.success(msg)
  vim.notify("✅ " .. msg, vim.log.levels.INFO, {title = "Learn CLI"})
end

function M.warn(msg)
  vim.notify("⚠️  " .. msg, vim.log.levels.WARN, {title = "Learn CLI"})
end

function M.error(msg)
  vim.notify("❌ " .. msg, vim.log.levels.ERROR, {title = "Learn CLI"})
end

return M
