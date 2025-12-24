# Learning Plan Template for learn-cli.nvim

## Table of content

  - [📋 Metadata](#metadata)
  - [🔄 Cycle Structure](#cycle-structure)
    - [Cycle 1](#cycle-1)
    - [Progression Across Iterations](#progression-across-iterations)
  - [📚 Info Unit Template](#info-unit-template)
    - [Info Unit A (before Half Cycle A)](#info-unit-a-before-half-cycle-a)
      - [Info File Structure](#info-file-structure)
  - [🎯 Learning Objectives](#learning-objectives)
  - [📖 Command Overview](#command-overview)
    - [Echo - Output and Redirects](#echo-output-and-redirects)
    - [Grep - Search Text](#grep-search-text)
    - [Find - Locate Files](#find-locate-files)
  - [🎮 Exercise Structure](#exercise-structure)
  - [📖 Further Reading](#further-reading)
    - [Books](#books)
    - [Online Resources](#online-resources)
    - [Man Pages](#man-pages)
    - [Interactive Tutorials](#interactive-tutorials)
  - [🔖 Cheat Sheet](#cheat-sheet)
    - [Quick Reference](#quick-reference)
  - [🎯 Exercise Template (Detailed)](#exercise-template-detailed)
    - [Day 1 - Program A1: Echo Basics](#day-1-program-a1-echo-basics)
      - [Exercise 1: Redirect and Append](#exercise-1-redirect-and-append)
      - [Exercise 2: Tee with Pipe](#exercise-2-tee-with-pipe)
      - [Exercise 3: Variable Expansion](#exercise-3-variable-expansion)
  - [📊 Progress Tracking](#progress-tracking)
  - [🏆 Gamification Elements](#gamification-elements)
  - [📈 Statistics & Reporting](#statistics-reporting)
  - [🗂️ File Structure in Plugin](#file-structure-in-plugin)
  - [🚀 Implementation Notes](#implementation-notes)
    - [Phase 1: Core System](#phase-1-core-system)
    - [Phase 2: Gamification](#phase-2-gamification)
    - [Phase 3: UI](#phase-3-ui)
    - [Phase 4: Content](#phase-4-content)
  - [📝 Notes for Content Creators](#notes-for-content-creators)
    - [Do's](#dos)
    - [Don'ts](#donts)
    - [Best Practices](#best-practices)

---

## 📋 Metadata

```yaml
plan_id: "cli_cycle_01"
title: "CLI Fundamentals - Cycle 1"
category: "basics" # basics, intermediate, advanced, expert
version: "1.0.0"
platform: ["linux", "macos"] # linux, macos, windows, powershell
created_at: "2025-01-01"
author: "Your Name"
language: "en"

# Timing
total_cycles: 2
iterations_per_cycle: 3
days_per_cycle: 6
duration_per_day: "15min"
duration_per_exercise: "5min"
estimated_total_duration: "108min" # 2 cycles × 3 iterations × 6 days × 15min

# Prerequisites
prerequisites:
  technical:
    - "Installed terminal (Bash/Zsh)"
    - "Neovim >= 0.9.0"
    - "Basic keyboard skills"
  knowledge:
    - "What is a terminal"
    - "How to open a terminal"

# Learning Objectives
objectives:
  - "Master echo, grep, find commands"
  - "Understand key flags and options"
  - "Apply in real-world scenarios"
  - "Learn PowerShell equivalents"

# Scoring System
scoring:
  points_per_exercise: 100
  speed_bonus: 20
  penalty_per_hint: 10
  passing_score: 60 # minimum 60% to pass

# Gamification
achievements:
  - id: "first_blood"
    name: "First Steps"
    description: "Complete first exercise"
    points: 50
  - id: "perfect_day"
    name: "Perfect Day"
    description: "Complete all 3 exercises in a day with 100%"
    points: 200
  - id: "speed_demon"
    name: "Speed Demon"
    description: "Complete 5 exercises under 30 seconds"
    points: 150
  - id: "no_hints"
    name: "Self-Taught"
    description: "Complete 10 exercises without hints"
    points: 300
```

---

## 🔄 Cycle Structure

### Cycle 1

```yaml
cycle_id: "cycle_01"
iteration: 1 # 1, 2, or 3
difficulty: "basic" # basic, intermediate, advanced

half_cycle_a:
  days: [1, 2, 3]
  platform: ["linux", "macos"]
  programs:
    - name: "echo"
      focus: "Output, Redirects, Variables"
    - name: "grep"
      focus: "Text Search, Patterns"
    - name: "find"
      focus: "File Search, Filters"

half_cycle_b:
  days: [4, 5, 6]
  platform: ["powershell"]
  programs:
    - name: "Write-Output / Out-File"
      equivalent_to: "echo"
    - name: "Select-String"
      equivalent_to: "grep"
    - name: "Get-ChildItem"
      equivalent_to: "find"
```

### Progression Across Iterations

```yaml
iteration_1:
  flags: ["basic", "common"]
  complexity: "simple"
  examples:
    echo: [">", ">>", "$VAR"]
    grep: ["pattern", "-v", "-n"]
    find: ["-name", "-type"]

iteration_2:
  flags: ["extended", "combinations"]
  complexity: "medium"
  examples:
    echo: ["|", "tee", "multiple redirects"]
    grep: ["-i", "-r", "regex"]
    find: ["-size", "-mtime", "-exec"]

iteration_3:
  flags: ["complex", "edge cases"]
  complexity: "advanced"
  examples:
    echo: ["quoting", "escape sequences", "process substitution"]
    grep: ["-A", "-B", "-C", "--color"]
    find: ["-prune", "-delete", "complex expressions"]
```

---

## 📚 Info Unit Template

### Info Unit A (before Half Cycle A)

```yaml
info_id: "info_cycle01_half_a_iter1"
title: "Introduction: echo, grep, find"
duration: "5-10min"
type: "reading"
path: "docs/cycles/cycle_01/iteration_1/info_a.md"
```

#### Info File Structure

```markdown
# Echo, Grep, Find - Fundamentals

## 🎯 Learning Objectives
- Understand output redirection
- Text search with patterns
- File system exploration

## 📖 Command Overview

### Echo - Output and Redirects

**Core Function**: Print text

**Key Flags/Operators**:
- `>` - Write output to file (overwrite)
- `>>` - Append output to file
- `|` - Pipe output to next command
- `$VAR` - Expand variable

**Examples**:
```bash
# Write to file
echo "hello world" > output.txt

# Append to file
echo "second line" >> output.txt

# Use variable
NAME="Max"
echo "Hello $NAME"

# Pipe with tee
echo "test" | tee file.txt
```

**Common Mistakes**:
- ❌ `echo text > file1 > file2` - doesn't work as expected
- ✅ `echo text | tee file1 > file2` - correct

**Pro Tips**:
- Use `>>` for appending
- Use `>` for overwriting
- `tee` is useful for output to screen AND file

---

### Grep - Search Text

**Core Function**: Find lines matching a pattern

**Key Flags**:
- `-v` - invert match (lines WITHOUT pattern)
- `-n` - show line numbers
- `-i` - ignore case
- `-r` - recursive in directories

**Examples**:
```bash
# Simple search
grep "error" logfile.txt

# With line numbers
grep -n "warning" logfile.txt

# Inverted
grep -v "debug" logfile.txt

# Regex
grep -E 'error|warning' logfile.txt
```

**Common Mistakes**:
- ❌ Forgetting grep uses POSIX regex
- ❌ No quotes around patterns with special chars

---

### Find - Locate Files

**Core Function**: Search filesystem by criteria

**Key Flags**:
- `-name "pattern"` - Name (with wildcards)
- `-type f` - files only
- `-type d` - directories only
- `-size +1M` - size filter
- `-exec cmd {} \;` - run command on each result

**Examples**:
```bash
# All .txt files
find . -name "*.txt"

# Files only, not directories
find . -type f -name "*.log"

# With exec
find . -name "*.tmp" -exec rm {} \;
```

**Common Mistakes**:
- ❌ Forgetting `-type` includes directories in results
- ❌ `*` without quotes can be expanded by shell

---

## 🎮 Exercise Structure

Over the next 3 days you will:
- **Day 1**: Echo basics, redirects, variables
- **Day 2**: Grep patterns, flags, regex
- **Day 3**: Find queries, filters, exec

Per day: 3 exercises à ~5 minutes each

**Tips**:
- Try without hints first
- Read error messages carefully
- If unsure: taking hints is OK!

---

## 📖 Further Reading

### Books
- "The Linux Command Line" by William Shotts
  - Chapter 6: Redirection
  - Chapter 17: Searching for Files

### Online Resources
- [GNU Grep Manual](https://www.gnu.org/software/grep/manual/)
- [Find Command Examples](https://www.tecmint.com/35-practical-examples-of-linux-find-command/)
- [Bash Redirections Cheat Sheet](https://catonmat.net/bash-one-liners-explained-part-three)

### Man Pages
```bash
man echo
man grep
man find
```

### Interactive Tutorials
- [explainshell.com](https://explainshell.com/) - Commands explained
- [Regex101](https://regex101.com/) - Test regex

---

## 🔖 Cheat Sheet

### Quick Reference

| Command | Function | Example |
|---------|----------|---------|
| `echo "text" > file` | Overwrite | `echo "new" > out.txt` |
| `echo "text" >> file` | Append | `echo "more" >> out.txt` |
| `grep pattern file` | Search | `grep "error" log.txt` |
| `grep -v pattern file` | Inverted | `grep -v "info" log.txt` |
| `find . -name "*.txt"` | By name | `find ~ -name "*.pdf"` |
| `find . -type f` | Files only | `find /var -type f` |

---

**Ready? Start with Day 1!**
```

---

## 🎯 Exercise Template (Detailed)

### Day 1 - Program A1: Echo Basics

```yaml
day_id: "day_01"
program_id: "A1_echo_basics"
half_cycle: "A"
iteration: 1
date: "2025-01-01"
exercises: 3
total_duration: "15min"

# Setup for all exercises today
setup:
  working_directory: "/tmp/learn-cli/cycle01/day01"
  required_files:
    - name: "input.txt"
      content: |
        alpha
        beta
        gamma
  cleanup_after_day: true
```

---

#### Exercise 1: Redirect and Append

```yaml
exercise_id: "ex_01_01_redirect"
title: "Redirect and append text"
duration: "5min"
difficulty: 1  # Scale 1-10
tags: ["redirect", "append", "basics"]
max_points: 100

# Task
task:
  description: |
    Write the text "hello world" to file `out.txt`.
    Then append the text "second line" to the same file.

  goal: |
    File `out.txt` should contain:
    hello world
    second line

  hints_before_start:
    - "Use '>' to overwrite"
    - "Use '>>' to append"

# Reference Solution
solution:
  primary_solution: |
    echo "hello world" > out.txt
    echo "second line" >> out.txt

  alternative_solutions:
    - |
      echo "hello world" > out.txt; echo "second line" >> out.txt
    - |
      echo -e "hello world\nsecond line" > out.txt

# Validation
validation:
  type: "file_content"
  file: "out.txt"
  expected_content: |
    hello world
    second line

  additional_checks:
    - type: "file_exists"
      file: "out.txt"
    - type: "line_count"
      file: "out.txt"
      expected: 2
    - type: "encoding"
      file: "out.txt"
      expected: "utf-8"

# Scoring
scoring:
  fully_correct: 100
  file_exists_wrong_content: 40
  only_one_line: 50
  wrong_order: 30

  time_bonus:
    under_30s: 20
    under_60s: 10
    under_90s: 5

  hint_penalty:
    hint_1: -10
    hint_2: -20
    hint_3: -30
    viewed_solution: -50

# Hints (progressive)
hints:
  - level: 1
    cost: 10
    type: "concept"
    text: |
      You need two commands:
      1. One to write (overwrite)
      2. One to append

  - level: 2
    cost: 20
    type: "syntax"
    text: |
      Redirection syntax:
      echo "TEXT" > FILE    # overwrite
      echo "TEXT" >> FILE   # append

  - level: 3
    cost: 30
    type: "partial_solution"
    text: |
      First command:
      echo "hello world" > out.txt

      Now append the second line...

  - level: 4
    cost: 50
    type: "full_solution"
    text: |
      Complete solution:
      echo "hello world" > out.txt
      echo "second line" >> out.txt

# Helpful Information
info:
  relevant_man_pages:
    - "man echo"
    - "man bash" # Section on Redirection

  relevant_docs:
    - path: "docs/references/redirection.md"
      section: "Basic Output Redirection"

  related_exercises:
    - "ex_01_02_tee_pipe"
    - "ex_02_01_grep_redirect"

  common_errors:
    - error: "Used '>' both times"
      explanation: "Second '>' overwrites entire file"
      solution: "Use '>>' for appending"

    - error: "No quotes around text"
      explanation: "Problematic with spaces"
      solution: "Always use quotes: echo \"text with spaces\""

# Feedback Messages
feedback:
  success:
    perfect: |
      🎉 Perfect! You correctly applied both redirections.

      You understood:
      - '>' overwrites a file
      - '>>' appends to a file

      Next step: Try 'tee' too!

    with_hints: |
      ✅ Done! The hints helped.

      Remember:
      - '>' = overwrite
      - '>>' = append

      Next time try without hints!

  errors:
    file_missing: |
      ❌ File 'out.txt' was not created.

      Check:
      - Did you run the echo command?
      - Did you use '>'?

    content_wrong: |
      ❌ File exists but content is incorrect.

      Expected:
      hello world
      second line

      Found:
      {actual_content}

      Tip: Check if you used '>>' for the second line.
```

---

#### Exercise 2: Tee with Pipe

```yaml
exercise_id: "ex_01_02_tee_pipe"
title: "Display and save simultaneously"
duration: "5min"
difficulty: 2
tags: ["pipe", "tee", "intermediate"]
max_points: 100

task:
  description: |
    Display content of `input.txt` on screen
    AND write it to file `copy.txt` at the same time.

    Use the 'tee' command for this.

  precondition:
    - "input.txt must exist"

  goal: |
    - Screen should show:
      alpha
      beta
      gamma

    - File copy.txt should contain same content

solution:
  primary_solution: |
    cat input.txt | tee copy.txt

  alternative_solutions:
    - |
      tee copy.txt < input.txt
    - |
      cat input.txt | tee copy.txt | cat

validation:
  checks:
    - type: "file_content"
      file: "copy.txt"
      expected_content_from: "input.txt"

    - type: "command_output"
      command: "cat copy.txt"
      expected_output: |
        alpha
        beta
        gamma

hints:
  - level: 1
    cost: 10
    text: |
      The 'tee' command reads from stdin and writes
      both to stdout and to a file.

      You need to pipe content from input.txt to tee.

  - level: 2
    cost: 20
    text: |
      Pattern: cat SOURCE | tee TARGET

      tee displays on screen AND writes to file.

  - level: 3
    cost: 30
    text: |
      Solution:
      cat input.txt | tee copy.txt
```

---

#### Exercise 3: Variable Expansion

```yaml
exercise_id: "ex_01_03_variables"
title: "Using variables"
duration: "5min"
difficulty: 2
tags: ["variables", "expansion"]
max_points: 100

task:
  description: |
    Create a variable NAME with your name.
    Then output "Hello $NAME".

    Save the output to file greeting.txt

  goal: |
    File greeting.txt should contain:
    Hello [Your Name]

    (where [Your Name] is the value of your variable)

solution:
  primary_solution: |
    NAME="Stefan"
    echo "Hello $NAME" > greeting.txt

  flexible: true  # Name can vary
  pattern: "Hello \\w+"

validation:
  checks:
    - type: "file_exists"
      file: "greeting.txt"

    - type: "pattern_match"
      file: "greeting.txt"
      regex: "^Hello \\w+$"

    - type: "not_literal"
      file: "greeting.txt"
      forbidden: "$NAME"  # Variable must be expanded

hints:
  - level: 1
    cost: 10
    text: |
      In Bash/Zsh you can set variables like:
      VARNAME="value"

      And use them like:
      echo "$VARNAME"

  - level: 2
    cost: 20
    text: |
      Two steps:
      1. NAME="YourName"
      2. echo "Hello $NAME" > greeting.txt

  - level: 3
    cost: 30
    text: |
      Complete solution:
      NAME="Stefan"
      echo "Hello $NAME" > greeting.txt

      (You can use a different name of course)
```

---

## 📊 Progress Tracking

```yaml
tracking:
  per_exercise:
    - start_time
    - end_time
    - duration_seconds
    - hints_used: []
    - attempts: 0
    - success: boolean
    - points_earned: 0
    - points_maximum: 100

  per_day:
    - day_number
    - exercises_completed: 0
    - exercises_total: 3
    - average_points: 0
    - average_time: 0
    - achievements_unlocked: []

  per_cycle:
    - cycle_id
    - iteration: 1
    - progress_percent: 0
    - days_completed: 0
    - days_total: 6
    - total_points: 0
    - average_per_exercise: 0

  global:
    - level: 1
    - experience_points: 0
    - streak: 0  # consecutive days
    - achievements_total: []
    - statistics:
        exercises_total: 0
        exercises_perfect: 0
        exercises_with_hints: 0
        average_time: 0
        fastest_time: 999
        slowest_time: 0
```

---

## 🏆 Gamification Elements

```yaml
achievements:
  # Basics
  - id: "first_steps"
    name: "First Steps"
    description: "Complete first exercise"
    condition: "exercises_completed >= 1"
    points: 50
    icon: "🚀"

  - id: "perfect_score"
    name: "Perfect Score"
    description: "Complete exercise with 100/100 points"
    condition: "any(exercise.points == 100)"
    points: 100
    icon: "💯"

  - id: "perfect_day"
    name: "Perfect Day"
    description: "All 3 exercises in a day with 100/100"
    condition: "all_exercises_today == 100"
    points: 300
    icon: "⭐"

  # Speed
  - id: "speed_runner"
    name: "Speed Runner"
    description: "Complete exercise in under 30 seconds"
    condition: "exercise.duration < 30"
    points: 75
    icon: "⚡"

  - id: "speed_demon"
    name: "Speed Demon"
    description: "5 exercises under 30 seconds"
    condition: "count(exercise.duration < 30) >= 5"
    points: 200
    icon: "🔥"

  # Learning
  - id: "autodidact"
    name: "Self-Taught"
    description: "10 exercises without hints"
    condition: "count(exercise.hints == 0) >= 10"
    points: 300
    icon: "🧠"

  - id: "persistent"
    name: "Persistent"
    description: "Complete exercise after 3+ attempts"
    condition: "exercise.attempts >= 3 and exercise.success"
    points: 150
    icon: "💪"

  # Progression
  - id: "half_cycle"
    name: "Half Time"
    description: "Complete first half cycle (3 days)"
    condition: "days_completed >= 3"
    points: 200
    icon: "🎯"

  - id: "full_cycle"
    name: "Full Cycle"
    description: "Complete full cycle (6 days)"
    condition: "cycle.days_completed == 6"
    points: 500
    icon: "🏆"

  - id: "cycle_master"
    name: "Cycle Master"
    description: "Repeat cycle 3 times"
    condition: "cycle.iterations >= 3"
    points: 1000
    icon: "👑"

  # Streaks
  - id: "three_day_streak"
    name: "Three Day Streak"
    description: "Practice 3 days in a row"
    condition: "streak >= 3"
    points: 150
    icon: "📅"

  - id: "week_warrior"
    name: "Week Warrior"
    description: "Practice 7 days in a row"
    condition: "streak >= 7"
    points: 500
    icon: "🗓️"

# Leaderboard
leaderboard:
  categories:
    - name: "Total Points"
      field: "total_points"
      sort: "desc"

    - name: "Exercises Completed"
      field: "exercises_total"
      sort: "desc"

    - name: "Perfect Scores"
      field: "exercises_perfect"
      sort: "desc"

    - name: "Average Time"
      field: "average_time"
      sort: "asc"

    - name: "Longest Streak"
      field: "max_streak"
      sort: "desc"

# Level System
level_system:
  experience_per_exercise: 25
  experience_per_achievement: "achievement.points / 10"

  levels:
    - level: 1
      name: "Novice"
      experience_required: 0
      icon: "🌱"

    - level: 2
      name: "Learner"
      experience_required: 250
      icon: "📚"

    - level: 3
      name: "Practitioner"
      experience_required: 750
      icon: "⚙️"

    - level: 4
      name: "Advanced"
      experience_required: 1500
      icon: "🎓"

    - level: 5
      name: "Expert"
      experience_required: 3000
      icon: "🌟"

    - level: 6
      name: "Master"
      experience_required: 5000
      icon: "👑"
```

---

## 📈 Statistics & Reporting

```yaml
statistics:
  exercise_level:
    - name: "Average Score"
      calculation: "sum(points) / count(exercises)"

    - name: "Average Time"
      calculation: "sum(duration) / count(exercises)"

    - name: "Success Rate"
      calculation: "(successes / attempts) * 100"

    - name: "Hint Usage"
      calculation: "sum(hints) / count(exercises)"

  day_level:
    - name: "Best Exercise"
      calculation: "max(exercise.points)"

    - name: "Worst Exercise"
      calculation: "min(exercise.points)"

    - name: "Trend"
      calculation: "compare(today, yesterday)"

  cycle_level:
    - name: "Progress"
      calculation: "(days_completed / days_total) * 100"

    - name: "Improvement"
      calculation: "compare(iteration_2, iteration_1)"

  global:
    - name: "Total Time"
      calculation: "sum(all_exercises.duration)"

    - name: "Most Common Errors"
      calculation: "group_by(error_type).count()"

reports:
  daily_report:
    content:
      - "Exercises today: X/3"
      - "Points today: Y"
      - "New achievements: Z"
      - "Streak: N days"
      - "Next goal: ..."

  weekly_report:
    content:
      - "Exercises this week: X"
      - "Average points: Y"
      - "Practiced commands: echo, grep, find"
      - "Strengths: ..."
      - "Improvement areas: ..."

  cycle_report:
    content:
      - "Cycle completed: X of 3"
      - "Overall progress: Y%"
      - "Mastered commands: ..."
      - "Next iteration: harder flags"
      - "Recommendation: ..."
```

---

## 🗂️ File Structure in Plugin

```
learn-cli.nvim/
├── exercises/
│   ├── cycles/
│   │   ├── cycle_01/
│   │   │   ├── metadata.yaml
│   │   │   ├── iteration_1/
│   │   │   │   ├── info_a.md
│   │   │   │   ├── info_b.md
│   │   │   │   ├── day_01/
│   │   │   │   │   ├── setup.lua
│   │   │   │   │   ├── ex_01.yaml
│   │   │   │   │   ├── ex_02.yaml
│   │   │   │   │   ├── ex_03.yaml
│   │   │   │   ├── day_02/
│   │   │   │   ├── day_03/
│   │   │   │   ├── day_04/
│   │   │   │   ├── day_05/
│   │   │   │   ├── day_06/
│   │   │   ├── iteration_2/
│   │   │   ├── iteration_3/
│   │   ├── cycle_02/
│   ├── templates/
│   │   ├── exercise_template.yaml
│   │   ├── info_template.md
│   │   ├── validation_template.lua
├── docs/
│   ├── references/
│   │   ├── commands/
│   │   │   ├── echo.md
│   │   │   ├── grep.md
│   │   │   ├── find.md
│   │   ├── concepts/
│   │   │   ├── redirection.md
│   │   │   ├── pipes.md
│   │   │   ├── regex.md
│   ├── literature/
│   │   ├── books.md
│   │   ├── online_resources.md
├── lua/
│   ├── learn_cli/
│   │   ├── core/
│   │   │   ├── exercise_runner.lua
│   │   │   ├── validator.lua
│   │   │   ├── scoring.lua
│   │   ├── state/
│   │   │   ├── progress.lua
│   │   │   ├── statistics.lua
│   │   ├── ui/
│   │   │   ├── dashboard.lua
│   │   │   ├── exercise_view.lua
│   │   │   ├── leaderboard.lua
│   │   ├── gamification/
│   │   │   ├── achievements.lua
│   │   │   ├── levels.lua
│   │   │   ├── streaks.lua
```

---

## 🚀 Implementation Notes

### Phase 1: Core System
1. Exercise Runner (loads and executes exercises)
2. Validation System (checks solutions)
3. Progress Tracking (saves progress)

### Phase 2: Gamification
1. Achievement System
2. Level/XP System
3. Streak Tracking

### Phase 3: UI
1. Dashboard (overview)
2. Exercise View (during exercise)
3. Statistics View (analytics)

### Phase 4: Content
1. Cycle 1 (echo, grep, find)
2. Cycle 2 (exec/read, cp/rm/mv, sh/ssh/tar)
3. PowerShell equivalents

---

## 📝 Notes for Content Creators

### Do's
- ✅ Clear, unambiguous task descriptions
- ✅ Realistic time estimates (5min)
- ✅ Accept multiple solution paths
- ✅ Progressive hints (concept to solution)
- ✅ Document common errors
- ✅ Provide further reading

### Don'ts
- ❌ Overly complex exercises (keep it simple!)
- ❌ Unclear success criteria
- ❌ Hints that reveal too much
- ❌ Unrealistic time limits
- ❌ Platform-specific commands without alternatives

### Best Practices
1. Test each exercise yourself
2. Validate all reference solutions
3. Check hints for clarity
4. Document edge cases
5. Provide context for each command

---

**This template serves as the foundation for all learning plans in learn-cli.nvim**
