---@module 'learn_cli.core.scorer'
---@brief Berechnet Punkte für Exercises

local M = {}

--- Berechnet Gesamtpunktzahl
---@param state table ExerciseState
---@param duration integer Dauer in Sekunden
---@return table score
function M.calculate_score(state, duration)
  local exercise = state.exercise
  local scoring = exercise.scoring or {}

  -- Basis-Punkte
  local points = scoring.correct or exercise.points_max or 100

  -- Zeit-Bonus
  if scoring.time_bonus then
    for time_str, bonus in pairs(scoring.time_bonus) do
      local time_limit = tonumber(time_str:match("%d+"))
      if time_limit and duration < time_limit then
        points = points + bonus
        break -- Nur den höchsten Bonus geben
      end
    end
  end

  -- Hint-Malus
  local hint_penalty_total = 0
  if scoring.hint_penalty then
    for _, hint_level in ipairs(state.hints_used) do
      local penalty = scoring.hint_penalty[tostring(hint_level)]
      if penalty then
        hint_penalty_total = hint_penalty_total + math.abs(penalty)
        points = points - math.abs(penalty)
      end
    end
  end

  -- Lösung angeschaut
  local solution_penalty = 0
  if state.solution_viewed and scoring.hint_penalty then
    solution_penalty = math.abs(scoring.hint_penalty.viewed_solution or 50)
    points = points - solution_penalty
  end

  -- Minimum 0
  points = math.max(0, points)

  local max_points = exercise.points_max or 100

  return {
    total = points,
    max = max_points,
    percentage = (points / max_points) * 100,
    base_points = scoring.correct or max_points,
    time_bonus = math.max(0, points - (scoring.correct or max_points) + hint_penalty_total + solution_penalty),
    hint_penalty = hint_penalty_total,
    solution_penalty = solution_penalty,
    hints_used = #state.hints_used,
    attempts = state.attempts,
    duration = duration,
  }
end

--- Berechnet minimale Punktzahl (mit allen Penalties)
---@param exercise table
---@return integer min_points
function M.calculate_min_score(exercise)
  local scoring = exercise.scoring or {}
  local points = scoring.correct or exercise.points_max or 100

  -- Alle Hints verwendet
  if scoring.hint_penalty then
    for _, penalty in pairs(scoring.hint_penalty) do
      if type(penalty) == "number" then
        points = points - math.abs(penalty)
      end
    end
  end

  return math.max(0, points)
end

--- Berechnet maximale Punktzahl (mit Zeit-Bonus)
---@param exercise table
---@return integer max_points
function M.calculate_max_score(exercise)
  local scoring = exercise.scoring or {}
  local points = scoring.correct or exercise.points_max or 100

  -- Bester Zeit-Bonus
  if scoring.time_bonus then
    local max_bonus = 0
    for _, bonus in pairs(scoring.time_bonus) do
      if type(bonus) == "number" then
        max_bonus = math.max(max_bonus, bonus)
      end
    end
    points = points + max_bonus
  end

  return points
end

return M
