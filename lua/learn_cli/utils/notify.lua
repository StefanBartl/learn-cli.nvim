---@module 'learn_cli.utils.notify'
---@brief Notification helper
---@description Delegates prefixing and level dispatch to lib.nvim.notify.
--- `success` has no lib.nvim.notify equivalent, so it stays a thin wrapper:
--- an emoji-prefixed message at INFO level.

local notifier = require("lib.nvim.notify").create("Learn CLI")

local M = {}

---@param msg string
function M.info(msg)
  notifier.info(msg)
end

---@param msg string
function M.success(msg)
  notifier.info("✅ " .. msg)
end

---@param msg string
function M.warn(msg)
  notifier.warn("⚠️  " .. msg)
end

---@param msg string
function M.error(msg)
  notifier.error("❌ " .. msg)
end

return M
