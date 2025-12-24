---@module 'learn_cli.data.exercises.grep'
---@brief Exercise definitions for grep command

---@type LearnCLI.Exercise[]
local exercises = {
  {
    id = "grep_basic_search",
    program = "grep",
    title = "Basic Text Search",
    description = "Learn to search for simple patterns in files using grep",
    difficulty = "beginner",
    target_time_seconds = 120, -- 2 minutes

    task = [[
You have a file called 'sample.txt' with various lines of text.

Task:
1. Search for lines containing the word "error"
2. Count how many lines match

Expected command structure: grep [options] "pattern" filename
    ]],

    hints = {
      "Use grep with the search term and filename",
      "The basic syntax is: grep 'pattern' filename",
      "To count matches, use the -c flag: grep -c 'pattern' filename",
    },

    files = {
      ["sample.txt"] = [[
This is a normal log line
ERROR: Something went wrong
Warning: Check this out
error in processing
Everything is fine
Another ERROR occurred
System error detected
All good here
        ]],
    },

    references = {
      "man grep",
      "https://www.gnu.org/software/grep/manual/grep.html",
      "grep --help",
    },

    tags = { "grep", "search", "text", "beginner" },
    prerequisites = {},
  },

  {
    id = "grep_case_insensitive",
    program = "grep",
    title = "Case-Insensitive Search",
    description = "Master the -i flag for case-insensitive pattern matching",
    difficulty = "beginner",
    target_time_seconds = 180, -- 3 minutes

    task = [[
Using the same 'sample.txt' file from the previous exercise.

Task:
1. Search for all lines containing "error" (case-insensitive)
2. This should match: "error", "ERROR", "Error", etc.
3. Display line numbers for each match

Expected result: Lines with different capitalizations of "error" with line numbers
    ]],

    hints = {
      "Use the -i flag to make grep case-insensitive",
      "Use the -n flag to show line numbers",
      "Combine flags like: grep -in 'pattern' filename",
    },

    files = {
      ["sample.txt"] = [[
This is a normal log line
ERROR: Something went wrong
Warning: Check this out
error in processing
Everything is fine
Another ERROR occurred
System error detected
All good here
        ]],
    },

    references = {
      "man grep",
      "grep --help | grep -i case",
    },

    tags = { "grep", "flags", "case-insensitive", "beginner" },
    prerequisites = { "grep_basic_search" },
  },

  {
    id = "grep_regex_basics",
    program = "grep",
    title = "Basic Regular Expressions",
    description = "Introduction to regex patterns with grep",
    difficulty = "intermediate",
    target_time_seconds = 300, -- 5 minutes

    task = [[
You have a file 'emails.txt' with various email addresses.

Task:
1. Find all lines that contain email addresses ending in .com
2. Use a basic regex pattern
3. Count the total number of matches

Hint: Email pattern ends with .com
    ]],

    hints = {
      "Use grep with -E for extended regex",
      "Pattern for emails: [a-z]+@[a-z]+\\.com",
      "Don't forget to escape the dot: \\.",
      "Use -c to count matches",
    },

    files = {
      ["emails.txt"] = [[
john@example.com
jane.doe@company.org
admin@test.com
support@website.net
info@business.com
contact@site.co.uk
        ]],
    },

    references = {
      "man grep | grep -A 10 'REGULAR EXPRESSIONS'",
      "https://www.regular-expressions.info/quickstart.html",
      "grep -E --help",
    },

    tags = { "grep", "regex", "patterns", "intermediate" },
    prerequisites = { "grep_basic_search", "grep_case_insensitive" },
  },

  {
    id = "grep_inverted_match",
    program = "grep",
    title = "Inverted Matching",
    description = "Learn to exclude lines with -v flag",
    difficulty = "intermediate",
    target_time_seconds = 240, -- 4 minutes

    task = [[
You have a log file 'server.log' with various log levels.

Task:
1. Display all lines that do NOT contain "DEBUG"
2. Save the output to a file called 'filtered.log'
3. Count how many lines remain

This is useful for filtering out verbose debug messages.
    ]],

    hints = {
      "Use -v flag to invert the match (exclude matching lines)",
      "Redirect output with >: grep -v 'pattern' file > output",
      "Chain with wc -l to count: grep -v 'pattern' file | wc -l",
    },

    files = {
      ["server.log"] = [[
2024-01-01 10:00:00 INFO Server started
2024-01-01 10:00:01 DEBUG Loading configuration
2024-01-01 10:00:02 DEBUG Connecting to database
2024-01-01 10:00:03 INFO Database connected
2024-01-01 10:00:04 DEBUG Processing request
2024-01-01 10:00:05 WARN High memory usage
2024-01-01 10:00:06 DEBUG Request completed
2024-01-01 10:00:07 ERROR Connection timeout
        ]],
    },

    references = {
      "man grep | grep -A 5 'invert'",
      "grep --help | grep -i invert",
    },

    tags = { "grep", "filtering", "inverted", "intermediate" },
    prerequisites = { "grep_basic_search" },
  },
}

return exercises
