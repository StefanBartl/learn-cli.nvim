---@module 'learn_cli.types'
---@brief Type definitions for learn-cli.nvim
---@description
--- Centralized type definitions to keep source code clean and maintainable.
--- All custom types, aliases, and class definitions are documented here.

-- #####################################################################
-- Core Types

---@alias LearnCLI.DifficultyLevel
---| "beginner"    # Basic commands and simple flags
---| "intermediate" # Combined flags and pipe operations
---| "advanced"     # Complex scenarios and edge cases
---| "expert"       # Performance optimization and advanced patterns

---@alias LearnCLI.ExerciseStatus
---| "not_started" # Exercise never attempted
---| "in_progress" # Currently working on it
---| "completed"   # Successfully completed at least once
---| "mastered"    # Completed multiple times with good scores

---@class LearnCLI.Exercise
---@field id string Unique identifier for the exercise
---@field program string CLI program name (e.g., "grep", "sed")
---@field title string Short descriptive title
---@field description string Detailed explanation of what to learn
---@field difficulty LearnCLI.DifficultyLevel Difficulty classification
---@field target_time_seconds number Expected completion time in seconds
---@field task string|table The actual task description shown to user
---@field verification function|nil Optional function to verify completion
---@field hints string[]|nil Array of progressive hints (each reveal affects score)
---@field files table<string, string>|nil Attached files: filename -> content
---@field references string[]|nil Links to docs, articles, man pages
---@field tags string[]|nil Searchable tags (e.g., "regex", "pipeline")
---@field prerequisites string[]|nil IDs of exercises that should be done first
---@field solution table|nil Solution information
---@field validation table|nil Validation rules
---@field scoring table|nil Scoring configuration
---@field setup table|nil Setup configuration for working directory

---@class LearnCLI.ExerciseAttempt
---@field exercise_id string Reference to Exercise.id
---@field timestamp number Unix timestamp when attempt started
---@field duration_seconds number How long the attempt took
---@field hints_used number Number of hints revealed
---@field completed boolean Whether the exercise was completed
---@field score number Calculated score (0-100)

---@class LearnCLI.ExerciseProgress
---@field exercise_id string Reference to Exercise.id
---@field status LearnCLI.ExerciseStatus Current status
---@field attempts LearnCLI.ExerciseAttempt[] History of all attempts
---@field best_score number Highest score achieved
---@field best_time number Fastest completion time
---@field total_attempts number Total number of attempts
---@field last_attempt_timestamp number|nil When last attempted
---@field mastery_level number 0-100, calculated from performance

---@class LearnCLI.Cycle
---@field id string Unique identifier
---@field name string Display name
---@field description string What this cycle covers
---@field exercise_ids string[] Ordered list of exercise IDs
---@field estimated_duration_minutes number Total expected time
---@field difficulty LearnCLI.DifficultyLevel Overall difficulty

---@class LearnCLI.CycleProgress
---@field cycle_id string Reference to Cycle.id
---@field started_at number|nil Unix timestamp
---@field completed_at number|nil Unix timestamp
---@field current_exercise_index number 0-based index
---@field completed_exercises string[] Exercise IDs completed in this cycle

-- #####################################################################
-- Configuration Types

---@class LearnCLI.Config
---@field data_dir string Where to store progress/state (default: stdpath("data")/learn_cli)
---@field cache_dir string|nil Cache directory for temporary files
---@field exercises_dir string|nil Custom exercises directory
---@field auto_save boolean Auto-save progress after each exercise
---@field auto_save_interval_ms number How often to auto-save (if enabled)
---@field ui LearnCLI.UIConfig UI-specific configuration
---@field scoring LearnCLI.ScoringConfig Scoring algorithm parameters
---@field timer LearnCLI.TimerConfig Timer behavior settings
---@field keymaps LearnCLI.KeymapsConfig Keymap configuration

---@class LearnCLI.UIConfig
---@field dashboard LearnCLI.DashboardConfig Dashboard settings
---@field exercise_view LearnCLI.ExerciseViewConfig Exercise view settings
---@field show_progress_bar boolean Show progress in statusline
---@field use_icons boolean Use nerd font icons

---@class LearnCLI.DashboardConfig
---@field width number|string Window width (number or "80%")
---@field height number|string Window height (number or "80%")
---@field border string Border style ("rounded", "single", "double", "none")
---@field show_stats boolean Show statistics panel
---@field show_recent boolean Show recent exercises
---@field recent_count number Number of recent exercises to show

---@class LearnCLI.ExerciseViewConfig
---@field width number|string Window width
---@field height number|string Window height
---@field border string Border style
---@field show_timer boolean Show countdown timer
---@field show_hints_count boolean Show number of available hints
---@field terminal_height number Height of integrated terminal

---@class LearnCLI.ScoringConfig
---@field base_score number Starting score (default: 100)
---@field hint_penalty number Score reduction per hint (default: 10)
---@field time_bonus_threshold number Time under target for bonus
---@field time_penalty_threshold number Time over target for penalty
---@field completion_bonus number Bonus for completing exercise

---@class LearnCLI.TimerConfig
---@field show_warnings boolean Show time warnings
---@field warning_at_percent number Show warning at X% of target time
---@field adaptive_target boolean Adjust target time based on performance
---@field adaptive_factor number Factor for adaptive adjustment (0.8-1.2)

---@class LearnCLI.KeymapsConfig
---@field prefix string Leader key prefix (default: "<leader>lc")
---@field dashboard string Open dashboard
---@field next_exercise string Go to next exercise
---@field prev_exercise string Go to previous exercise
---@field show_hint string Reveal next hint
---@field complete_exercise string Mark exercise as complete
---@field quit string Close current view

-- #####################################################################
-- State Types

---@class LearnCLI.State
---@field exercises table<string, LearnCLI.Exercise> All available exercises
---@field cycles table<string, LearnCLI.Cycle> All defined cycles
---@field progress table<string, LearnCLI.ExerciseProgress> Progress per exercise
---@field cycle_progress table<string, LearnCLI.CycleProgress> Progress per cycle
---@field current_exercise_id string|nil Currently active exercise
---@field current_cycle_id string|nil Currently active cycle
---@field session_start number|nil Unix timestamp of session start
---@field total_practice_time number Total seconds practiced

---@class LearnCLI.UIState
---@field dashboard_buf number|nil Dashboard buffer handle
---@field dashboard_win number|nil Dashboard window handle
---@field exercise_buf number|nil Exercise view buffer handle
---@field exercise_win number|nil Exercise view window handle
---@field terminal_buf number|nil Terminal buffer handle
---@field terminal_win number|nil Terminal window handle

-- #####################################################################
-- API Return Types

---@class LearnCLI.OperationResult
---@field ok boolean Whether operation succeeded
---@field error string|nil Error message if failed
---@field data any|nil Operation-specific return data

---@class LearnCLI.ValidationResult
---@field valid boolean Whether validation passed
---@field message string Error/Success message
---@field details table|string[]|nil Additional validation details

-- #####################################################################
-- Cycle Manager Types

---@class CycleMetadata
---@field cycle_id string Unique cycle identifier
---@field title string Display title
---@field version string Version string
---@field iterations integer Number of iterations
---@field days_per_cycle integer Days per cycle
---@field duration_per_day string Duration per day (e.g. "15min")
---@field platforms string[] Supported platforms
---@field category string Category (basics, intermediate, advanced)
---@field objectives string[] Learning objectives

---@class CycleProgressData
---@field current_iteration integer Current iteration (1-based)
---@field current_day integer Current day (1-based)
---@field current_exercise integer Current exercise (1-based)
---@field completed boolean Whether cycle is completed

---@class CycleData
---@field metadata CycleMetadata Cycle metadata
---@field data table Raw YAML/JSON data
---@field progress CycleProgressData Progress information

-- #####################################################################
-- Exercise Runner Types

---@class ExerciseState
---@field exercise LearnCLI.Exercise Exercise definition
---@field cycle_id string Cycle ID
---@field iteration integer Iteration number
---@field day integer Day number
---@field exercise_number integer Exercise number
---@field start_time integer Unix timestamp
---@field attempts integer Number of attempts
---@field hints_used integer[] Used hint levels
---@field solution_viewed boolean Whether solution was viewed
---@field working_dir string Working directory path
---@field status string Status (running, completed, failed)
---@field original_dir string Original working directory

---@class ExerciseResult
---@field success boolean Whether submission was successful
---@field score table|nil Score details
---@field duration integer|nil Duration in seconds
---@field attempts integer|nil Number of attempts
---@field errors string[]|nil Validation errors

-- #####################################################################
-- Validation Types

---@class ValidationConfig
---@field type string Validation type (file_content, command_output, etc.)
---@field file string|nil File to validate
---@field command string|nil Command to run
---@field expected string|nil Expected content/output
---@field expected_from_file string|nil Expected content from file
---@field expected_lines string[]|nil Expected lines (unordered)
---@field must_contain string[]|nil Strings that must be present
---@field regex string|nil Regex pattern to match
---@field forbidden_literal string|nil Literal that must not be present
---@field checks ValidationConfig[]|nil Multiple validation checks

---@class ValidationResult
---@field success boolean Whether validation passed
---@field errors string[] Error messages

-- #####################################################################
-- Scoring Types

---@class ScoreResult
---@field total integer Total score
---@field max integer Maximum possible score
---@field percentage number Percentage (0-100)
---@field base_points integer Base points
---@field time_bonus integer Time bonus points
---@field hint_penalty integer Hint penalty points
---@field solution_penalty integer Solution penalty points
---@field hints_used integer Number of hints used
---@field attempts integer Number of attempts
---@field duration integer Duration in seconds

return {}
