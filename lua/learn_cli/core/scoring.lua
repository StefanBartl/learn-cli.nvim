---@module 'learn_cli.core.scoring'
---@brief Score calculation engine with adaptive algorithms
---@description
--- Calculates exercise scores based on completion time, hints used,
--- and other performance metrics. Supports adaptive difficulty.

local config = require("learn_cli.config")

---@class LearnCLI.ScoringEngine
local M = {}

---Calculate score for an exercise attempt
---@param exercise LearnCLI.Exercise The exercise definition
---@param duration_seconds number How long the attempt took
---@param hints_used number Number of hints revealed
---@param completed boolean Whether exercise was completed
---@return number score Final score (0-100)
---@return table details Breakdown of score calculation
function M.calculate_score(exercise, duration_seconds, hints_used, completed)
  local scoring_config = config.get("scoring")
  local score = scoring_config.base_score
  local details = {
    base = scoring_config.base_score,
    penalties = {},
    bonuses = {}
  }

  -- Not completed = 0 score
  if not completed then
    return 0, {
      base = 0,
      penalties = { "exercise_not_completed" },
      bonuses = {}
    }
  end

  -- Hint penalties
  if hints_used > 0 then
    local hint_penalty = hints_used * scoring_config.hint_penalty
    score = score - hint_penalty
    table.insert(details.penalties, {
      type = "hints",
      amount = hint_penalty,
      count = hints_used
    })
  end

  -- Time-based adjustments
  local target_time = exercise.target_time_seconds
  local time_ratio = duration_seconds / target_time

  if time_ratio < scoring_config.time_bonus_threshold then
    -- Completed faster than threshold = bonus
    local bonus = math.floor((1 - time_ratio) * 20)
    score = score + bonus
    table.insert(details.bonuses, {
      type = "time_bonus",
      amount = bonus,
      ratio = time_ratio
    })
  elseif time_ratio > scoring_config.time_penalty_threshold then
    -- Took longer than threshold = penalty
    local penalty = math.floor((time_ratio - 1) * 10)
    score = score - penalty
    table.insert(details.penalties, {
      type = "time_penalty",
      amount = penalty,
      ratio = time_ratio
    })
  end

  -- Completion bonus
  score = score + scoring_config.completion_bonus
  table.insert(details.bonuses, {
    type = "completion",
    amount = scoring_config.completion_bonus
  })

  -- Clamp to 0-100 range
  score = math.max(0, math.min(100, score))

  details.final = score
  return score, details
end

---Calculate mastery level based on attempt history
---@param attempts LearnCLI.ExerciseAttempt[] All attempts for an exercise
---@return number mastery Mastery level (0-100)
function M.calculate_mastery(attempts)
  if #attempts == 0 then
    return 0
  end

  -- Get recent attempts (last 5)
  local recent_count = math.min(5, #attempts)
  local recent = {}
  for i = #attempts - recent_count + 1, #attempts do
    table.insert(recent, attempts[i])
  end

  -- Calculate average score of recent attempts
  local total_score = 0
  local completed_count = 0

  for _, attempt in ipairs(recent) do
    if attempt.completed then
      total_score = total_score + attempt.score
      completed_count = completed_count + 1
    end
  end

  if completed_count == 0 then
    return 0
  end

  local avg_score = total_score / completed_count

  -- Boost for consistency (all recent attempts completed)
  local consistency_bonus = 0
  if completed_count == recent_count and recent_count >= 3 then
    consistency_bonus = 10
  end

  -- Boost for total attempts (experience)
  local experience_bonus = math.min(10, #attempts)

  local mastery = math.min(100, avg_score + consistency_bonus + experience_bonus)
  return mastery
end

---Suggest next difficulty level based on mastery
---@param current_difficulty LearnCLI.DifficultyLevel Current exercise difficulty
---@param mastery_level number Mastery level (0-100)
---@return LearnCLI.DifficultyLevel|nil suggested Next suggested difficulty or nil if stay
function M.suggest_difficulty(current_difficulty, mastery_level)
  local difficulty_order = { "beginner", "intermediate", "advanced", "expert" }

  -- Find current index
  local current_idx = 1
  for i, diff in ipairs(difficulty_order) do
    if diff == current_difficulty then
      current_idx = i
      break
    end
  end

  -- Suggest progression at 80+ mastery
  if mastery_level >= 80 and current_idx < #difficulty_order then
    return difficulty_order[current_idx + 1]
  end

  -- Suggest demotion at <40 mastery (except if beginner)
  if mastery_level < 40 and current_idx > 1 then
    return difficulty_order[current_idx - 1]
  end

  return nil -- Stay at current level
end

---Calculate adaptive target time based on performance
---@param exercise LearnCLI.Exercise The exercise
---@param recent_attempts LearnCLI.ExerciseAttempt[] Recent attempts (last 3-5)
---@return number adjusted_target New target time in seconds
function M.calculate_adaptive_target(exercise, recent_attempts)
  local timer_config = config.get("timer")

  if not timer_config.adaptive_target or #recent_attempts == 0 then
    return exercise.target_time_seconds
  end

  -- Calculate average completion time from recent attempts
  local total_time = 0
  local count = 0

  for _, attempt in ipairs(recent_attempts) do
    if attempt.completed then
      total_time = total_time + attempt.duration_seconds
      count = count + 1
    end
  end

  if count == 0 then
    return exercise.target_time_seconds
  end

  local avg_time = total_time / count
  local base_target = exercise.target_time_seconds

  -- Adjust target toward average performance
  local adjusted = base_target + (avg_time - base_target) * timer_config.adaptive_factor

  -- Keep within reasonable bounds (50% to 200% of original)
  adjusted = math.max(base_target * 0.5, math.min(base_target * 2, adjusted))

  return math.floor(adjusted)
end

return M
