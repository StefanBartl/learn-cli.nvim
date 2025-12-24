# Zyklus 1 - Echo, Grep, Find (Komplett)

metadata:
  cycle_id: "cycle_01"
  title: "CLI Basics: echo, grep, find"
  category: "basics"
  version: "1.0.0"
  platforms: ["linux", "macos", "powershell"]
  iterations: 3
  days_per_cycle: 6
  duration_per_day: "15min"

  objectives:
    - "Master basic echo operations (>, >>, |, tee)"
    - "Use grep for text searching (patterns, -v, -n, regex)"
    - "Find files efficiently (-name, -type, -size, -exec)"
    - "Learn PowerShell equivalents"

# =====================================================================
# ITERATION 1 - Grundlagen
# =====================================================================

iteration_1:
  difficulty: "basic"
  focus: "Grundlegende Flags und häufigste Anwendungsfälle"

  # ---------------------------------------------------------------------
  # HALBZYKLUS A - Linux/macOS
  # ---------------------------------------------------------------------

  half_cycle_a:
    info_unit:
      id: "info_cycle01_iter1_half_a"
      title: "Einführung: echo, grep, find - Basics"
      duration: "5-10min"
      file: "docs/cycles/cycle_01/iteration_1/info_a.md"
      content_summary:
        echo:
          - "Grundfunktion: Text ausgeben"
          - "Redirect: > (überschreiben), >> (anhängen)"
          - "Pipe: | (an nächsten Befehl)"
          - "tee: gleichzeitig anzeigen und speichern"
          - "Variablen: $VAR"
        grep:
          - "Grundfunktion: Zeilen mit Muster finden"
          - "Flags: -v (invertiert), -n (Zeilennummern)"
          - "Einfache Regex: 'warn|error'"
        find:
          - "Grundfunktion: Dateien nach Kriterien suchen"
          - "Flags: -name (Name mit Wildcards)"
          - "Flags: -type f/d (Dateien/Verzeichnisse)"
          - "Flags: -size +/-NNN (Größe)"
          - "-exec: Befehl auf Ergebnisse anwenden"

      literature:
        books:
          - title: "The Linux Command Line"
            author: "William Shotts"
            chapters: ["6", "17"]
            url: "https://linuxcommand.org/tlcl.php"

        online:
          - title: "GNU Grep Manual"
            url: "https://www.gnu.org/software/grep/manual/"
          - title: "Find Command Examples (35 Practical)"
            url: "https://www.tecmint.com/35-practical-examples-of-linux-find-command/"
          - title: "Bash Redirection Guide"
            url: "https://catonmat.net/bash-one-liners-explained-part-three"

        man_pages: ["echo", "grep", "find", "bash"]

        interactive:
          - title: "ExplainShell"
            url: "https://explainshell.com/"
          - title: "Regex101"
            url: "https://regex101.com/"

    # Day 1: Echo
    day_01:
      program_id: "A1_echo"
      setup:
        working_dir: "/tmp/learn-cli/cycle01/iter1/day01"
        files:
          - name: "input.txt"
            content: |
              alpha
              beta
              gamma

      exercises:
        # Exercise 1
        - id: "ex_01_01_redirect"
          title: "Redirect und Append"
          duration: "5min"
          difficulty: 1
          points_max: 100
          tags: ["echo", "redirect", "append"]

          task:
            description: |
              Schreibe "hello world" in Datei out.txt
              Hänge dann "second line" an dieselbe Datei an

            expected_result: |
              Datei out.txt sollte enthalten:
              hello world
              second line

          solution:
            primary: |
              echo "hello world" > out.txt
              echo "second line" >> out.txt

            alternatives:
              - 'echo "hello world" > out.txt; echo "second line" >> out.txt'
              - 'echo -e "hello world\nsecond line" > out.txt'

          validation:
            type: "file_content"
            file: "out.txt"
            expected: |
              hello world
              second line
            checks:
              - type: "file_exists"
                file: "out.txt"
              - type: "line_count"
                expected: 2

          scoring:
            correct: 100
            file_exists_wrong_content: 40
            one_line_only: 50
            wrong_order: 30
            time_bonus:
              30s: 20
              60s: 10
            hint_penalty:
              1: -10
              2: -20
              3: -30

          hints:
            - level: 1
              cost: 10
              type: "concept"
              text: "Du brauchst zwei Befehle: einen zum Überschreiben (>), einen zum Anhängen (>>)"

            - level: 2
              cost: 20
              type: "syntax"
              text: |
                Syntax:
                echo "TEXT" > DATEI    # neu schreiben
                echo "TEXT" >> DATEI   # anhängen

            - level: 3
              cost: 30
              type: "partial"
              text: "echo \"hello world\" > out.txt"

            - level: 4
              cost: 50
              type: "solution"
              text: |
                Lösung:
                echo "hello world" > out.txt
                echo "second line" >> out.txt

          feedback:
            success:
              perfect: |
                🎉 Perfekt! Du hast beide Redirections korrekt verwendet.
                > überschreibt, >> hängt an.

              with_hints: "✅ Geschafft mit Hints! Nächstes Mal ohne?"

            errors:
              file_missing: "❌ Datei out.txt wurde nicht erstellt. Hast du '>' verwendet?"
              content_wrong: "❌ Datei existiert, aber Inhalt stimmt nicht. Prüfe ob du '>>' für Zeile 2 benutzt hast."
              only_one_line: "❌ Nur eine Zeile gefunden. Die zweite Zeile fehlt. Hast du '>>' verwendet?"

        # Exercise 2
        - id: "ex_01_02_tee"
          title: "Tee mit Pipe"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["echo", "pipe", "tee"]

          task:
            description: |
              Zeige Inhalt von input.txt auf dem Bildschirm
              UND schreibe ihn gleichzeitig nach copy.txt

              Nutze dafür 'tee'

            expected_result: |
              Bildschirm zeigt:
              alpha
              beta
              gamma

              Datei copy.txt enthält dasselbe

          solution:
            primary: "cat input.txt | tee copy.txt"
            alternatives:
              - "tee copy.txt < input.txt"
              - "cat input.txt | tee copy.txt | cat"

          validation:
            type: "multi"
            checks:
              - type: "file_content"
                file: "copy.txt"
                expected_from_file: "input.txt"
              - type: "command_output"
                command: "cat copy.txt"
                expected: |
                  alpha
                  beta
                  gamma

          hints:
            - level: 1
              cost: 10
              text: "'tee' liest von stdin, schreibt nach stdout UND in Datei"

            - level: 2
              cost: 20
              text: "Schema: cat QUELLE | tee ZIEL"

            - level: 3
              cost: 30
              text: "Lösung: cat input.txt | tee copy.txt"

        # Exercise 3
        - id: "ex_01_03_variables"
          title: "Variablenexpansion"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["echo", "variables", "expansion"]

          task:
            description: |
              Erstelle Variable NAME="DeinName"
              Gib "Hello $NAME" aus
              Speichere in greeting.txt

            expected_result: "Hello [beliebiger Name]"

          solution:
            primary: |
              NAME="Stefan"
              echo "Hello $NAME" > greeting.txt
            flexible: true
            pattern: "^Hello \\w+$"

          validation:
            type: "pattern"
            file: "greeting.txt"
            regex: "^Hello \\w+$"
            forbidden_literal: "$NAME"

          hints:
            - level: 1
              cost: 10
              text: "Variable setzen: NAME=\"wert\"\nVariable nutzen: echo \"$NAME\""

            - level: 2
              cost: 20
              text: |
                1. NAME="DeinName"
                2. echo "Hello $NAME" > greeting.txt

            - level: 3
              cost: 30
              text: |
                NAME="Stefan"
                echo "Hello $NAME" > greeting.txt

    # Day 2: Grep
    day_02:
      program_id: "A2_grep"
      setup:
        working_dir: "/tmp/learn-cli/cycle01/iter1/day02"
        files:
          - name: "data.txt"
            content: |
              error: disk full
              info: started
              warning: low memory
              error: network

      exercises:
        # Exercise 1
        - id: "ex_02_01_simple_search"
          title: "Einfache Suche"
          duration: "5min"
          difficulty: 1
          points_max: 100
          tags: ["grep", "search", "basic"]

          task:
            description: |
              Finde alle Zeilen in data.txt die "error" enthalten

            expected_output: |
              error: disk full
              error: network

          solution:
            primary: "grep error data.txt"
            alternatives:
              - 'grep "error" data.txt'
              - "cat data.txt | grep error"

          validation:
            type: "command_output"
            command: "grep error data.txt"
            expected: |
              error: disk full
              error: network

          hints:
            - level: 1
              cost: 10
              text: "grep findet Zeilen die einem Muster entsprechen"

            - level: 2
              cost: 20
              text: "Syntax: grep MUSTER DATEI"

            - level: 3
              cost: 30
              text: "Lösung: grep error data.txt"

        # Exercise 2
        - id: "ex_02_02_inverted"
          title: "Invertierte Suche"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["grep", "invert", "flag"]

          task:
            description: |
              Finde alle Zeilen die NICHT "error" enthalten
              Nutze Flag -v

            expected_output: |
              info: started
              warning: low memory

          solution:
            primary: "grep -v error data.txt"
            alternatives:
              - 'grep -v "error" data.txt'

          validation:
            type: "command_output"
            command: "grep -v error data.txt"
            expected: |
              info: started
              warning: low memory

          hints:
            - level: 1
              cost: 10
              text: "Das Flag -v invertiert die Suche"

            - level: 2
              cost: 20
              text: "grep -v MUSTER zeigt Zeilen OHNE das Muster"

            - level: 3
              cost: 30
              text: "Lösung: grep -v error data.txt"

        # Exercise 3
        - id: "ex_02_03_line_numbers_regex"
          title: "Zeilennummern und Regex"
          duration: "5min"
          difficulty: 3
          points_max: 150
          tags: ["grep", "regex", "line-numbers"]

          task:
            description: |
              Finde Zeilen mit "warn" ODER "error"
              Zeige Zeilennummern
              Nutze Regex: 'warn|error'
              Nutze Flag -n für Zeilennummern

            expected_output: |
              1:error: disk full
              3:warning: low memory
              4:error: network

          solution:
            primary: "grep -n 'warn\\|error' data.txt"
            alternatives:
              - 'grep -nE "warn|error" data.txt'
              - "grep -n -E 'warn|error' data.txt"

          validation:
            type: "command_output"
            command: "grep -n 'warn\\|error' data.txt"
            expected: |
              1:error: disk full
              3:warning: low memory
              4:error: network

          hints:
            - level: 1
              cost: 10
              text: "-n zeigt Zeilennummern\nPipe | für ODER in Regex"

            - level: 2
              cost: 20
              text: "grep -n 'muster1\\|muster2' DATEI"

            - level: 3
              cost: 30
              text: "Lösung: grep -n 'warn\\|error' data.txt"

    # Day 3: Find
    day_03:
      program_id: "A3_find"
      setup:
        working_dir: "/tmp/learn-cli/cycle01/iter1/day03"
        structure:
          - "find-test/"
          - "find-test/a.txt"
          - "find-test/b.log"
          - "find-test/sub/"
          - "find-test/sub/c.txt"
          - "find-test/sub/d.log"

      exercises:
        # Exercise 1
        - id: "ex_03_01_name_type"
          title: "Nach Name und Typ filtern"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["find", "name", "type"]

          task:
            description: |
              Finde alle .txt Dateien in find-test/
              Nutze -name für Pattern
              Nutze -type f für nur Dateien (keine Verzeichnisse)

            expected_output: |
              find-test/a.txt
              find-test/sub/c.txt

          solution:
            primary: 'find find-test -type f -name "*.txt"'
            alternatives:
              - 'find find-test -name "*.txt" -type f'

          validation:
            type: "command_output_unordered"
            command: 'find find-test -type f -name "*.txt"'
            expected_lines:
              - "find-test/a.txt"
              - "find-test/sub/c.txt"

          hints:
            - level: 1
              cost: 10
              text: "find durchsucht Verzeichnisbäume\n-name für Wildcards\n-type f für Dateien"

            - level: 2
              cost: 20
              text: 'find VERZEICHNIS -type f -name "*.ENDUNG"'

            - level: 3
              cost: 30
              text: 'Lösung: find find-test -type f -name "*.txt"'

        # Exercise 2
        - id: "ex_03_02_size"
          title: "Nach Größe filtern"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["find", "size"]

          task:
            description: |
              Finde alle Dateien größer als 0 Bytes
              Nutze -size +0c

            expected_output: "Alle nicht-leeren Dateien"

          solution:
            primary: "find find-test -type f -size +0c"

          validation:
            type: "command_success"
            command: "find find-test -type f -size +0c"

          hints:
            - level: 1
              cost: 10
              text: "-size +0c findet Dateien größer als 0 Bytes"

            - level: 2
              cost: 20
              text: "find VERZEICHNIS -type f -size +0c"

            - level: 3
              cost: 30
              text: "Lösung: find find-test -type f -size +0c"

        # Exercise 3
        - id: "ex_03_03_exec"
          title: "Exec auf Ergebnisse"
          duration: "5min"
          difficulty: 3
          points_max: 150
          tags: ["find", "exec", "advanced"]

          task:
            description: |
              Finde alle .log Dateien
              Zähle Zeilen in jeder Datei mit wc -l
              Nutze -exec wc -l {} \;

            expected_output: |
              0 find-test/b.log
              0 find-test/sub/d.log

          solution:
            primary: 'find find-test -name "*.log" -exec wc -l {} \;'

          validation:
            type: "command_contains"
            command: 'find find-test -name "*.log" -exec wc -l {} \;'
            must_contain: [".log"]

          hints:
            - level: 1
              cost: 10
              text: "-exec führt Befehl auf jedes Ergebnis aus\n{} wird durch Dateiname ersetzt"

            - level: 2
              cost: 20
              text: 'find ... -exec BEFEHL {} \;'

            - level: 3
              cost: 30
              text: 'Lösung: find find-test -name "*.log" -exec wc -l {} \;'

  # ---------------------------------------------------------------------
  # HALBZYKLUS B - PowerShell
  # ---------------------------------------------------------------------

  half_cycle_b:
    info_unit:
      id: "info_cycle01_iter1_half_b"
      title: "PowerShell Äquivalente zu echo, grep, find"
      duration: "5-10min"
      file: "docs/cycles/cycle_01/iteration_1/info_b.md"
      content_summary:
        echo_equivalent:
          - "Write-Output für einfache Ausgabe"
          - "Out-File mit -Append für Redirects"
        grep_equivalent:
          - "Select-String für Textsuche"
          - "-NotMatch für invertierte Suche"
        find_equivalent:
          - "Get-ChildItem für Dateisuche"
          - "-Recurse für rekursive Suche"
          - "Where-Object für Filterung"

    # Day 4: PowerShell Echo
    day_04:
      program_id: "B1_powershell_echo"
      platform: "powershell"

      exercises:
        - id: "ex_04_01_out_file"
          title: "Out-File und Append"
          duration: "5min"
          difficulty: 2
          points_max: 100
          tags: ["powershell", "output", "file"]

          task:
            description: |
              Schreibe "hello world" in out.txt
              Hänge "second line" an

              Nutze Out-File mit -Append

          solution:
            primary: |
              "hello world" | Out-File out.txt
              "second line" | Out-File out.txt -Append
            alternatives:
              - 'Write-Output "hello world" | Out-File out.txt; "second line" | Out-File out.txt -Append'

          validation:
            type: "file_content"
            file: "out.txt"
            expected: |
              hello world
              second line

        - id: "ex_04_02_write_output"
          title: "Write-Output"
          duration: "5min"
          difficulty: 1
          points_max: 100

          task:
            description: "Nutze Write-Output statt echo"

          solution:
            primary: 'Write-Output "Hello World"'

        - id: "ex_04_03_variables"
          title: "PowerShell Variablen"
          duration: "5min"
          difficulty: 2
          points_max: 100

          task:
            description: |
              Erstelle Variable $Name
              Gib "Hello $Name" aus

          solution:
            primary: |
              $Name = "Stefan"
              Write-Output "Hello $Name"

    # Day 5: PowerShell Grep
    day_05:
      program_id: "B2_powershell_grep"
      platform: "powershell"

      exercises:
        - id: "ex_05_01_select_string"
          title: "Select-String Basic"
          duration: "5min"
          difficulty: 2
          points_max: 100

          task:
            description: "Suche 'error' in data.txt mit Select-String"

          solution:
            primary: 'Select-String -Pattern "error" data.txt'

        - id: "ex_05_02_not_match"
          title: "NotMatch"
          duration: "5min"
          difficulty: 2
          points_max: 100

          task:
            description: "Finde Zeilen OHNE 'error'"

          solution:
            primary: 'Select-String -NotMatch "error" data.txt'

        - id: "ex_05_03_regex"
          title: "Regex mit Select-String"
          duration: "5min"
          difficulty: 3
          points_max: 150

          task:
            description: "Suche 'warn' ODER 'error'"

          solution:
            primary: 'Select-String -Pattern "warn|error" data.txt'

    # Day 6: PowerShell Find
    day_06:
      program_id: "B3_powershell_find"
      platform: "powershell"

      exercises:
        - id: "ex_06_01_get_childitem"
          title: "Get-ChildItem rekursiv"
          duration: "5min"
          difficulty: 2
          points_max: 100

          task:
            description: "Finde alle .txt Dateien rekursiv"

          solution:
            primary: 'Get-ChildItem -Recurse -Filter *.txt'

        - id: "ex_06_02_where_object"
          title: "Where-Object für Größe"
          duration: "5min"
          difficulty: 3
          points_max: 100

          task:
            description: "Finde Dateien größer als 0 Bytes"

          solution:
            primary: 'Get-ChildItem -Recurse | Where-Object Length -gt 0'

        - id: "ex_06_03_foreach"
          title: "ForEach-Object"
          duration: "5min"
          difficulty: 3
          points_max: 150

          task:
            description: "Zähle Zeilen in jeder .log Datei"

          solution:
            primary: 'Get-ChildItem -Recurse -Filter *.log | ForEach-Object { (Get-Content $_).Count }'

# =====================================================================
# ITERATION 2 - Erweitert
# =====================================================================

iteration_2:
  difficulty: "intermediate"
  focus: "Erweiterte Flags, Kombinationen, komplexere Szenarien"

  changes_from_iteration_1:
    echo:
      new_flags: ["tee -a", "multiple pipes", "subshells"]
      new_concepts: ["process substitution", "command substitution"]
    grep:
      new_flags: ["-i", "-r", "-A", "-B", "-C", "--color"]
      new_concepts: ["extended regex", "recursive search", "context lines"]
    find:
      new_flags: ["-mtime", "-newer", "-perm", "-user"]
      new_concepts: ["time-based search", "permission filtering"]

  # Analog zu Iteration 1, aber mit erweiterten Flags

# =====================================================================
# ITERATION 3 - Fortgeschritten
# =====================================================================

iteration_3:
  difficulty: "advanced"
  focus: "Komplexe Kombinationen, Edge Cases, Performance"

  changes_from_iteration_2:
    echo:
      new_concepts: ["here documents", "here strings", "advanced quoting"]
    grep:
      new_flags: ["-P", "-o", "-z"]
      new_concepts: ["perl regex", "null-terminated", "only matching"]
    find:
      new_flags: ["-prune", "-delete", "-printf"]
      new_concepts: ["exclude directories", "safe deletion", "custom output"]

# =====================================================================
# ACHIEVEMENTS FÜR CYCLE 1
# =====================================================================

achievements:
  cycle_specific:
    - id: "echo_master"
      name: "Echo Meister"
      description: "Alle echo Exercises mit 100% abgeschlossen"
      condition: "all_exercises_of_type('echo').score == 100"
      points: 200

    - id: "grep_guru"
      name: "Grep Guru"
      description: "Alle grep Exercises ohne Hints"
      condition: "all_exercises_of_type('grep').hints == 0"
      points: 300

    - id: "find_expert"
      name: "Find Experte"
      description: "Alle find Exercises unter 3 Minuten"
      condition: "all_exercises_of_type('find').time < 180"
      points: 250

    - id: "powershell_convert"
      name: "PowerShell Konvertit"
      description: "Halbzyklus B abgeschlossen"
      condition: "half_cycle_b.completed == true"
      points: 300

    - id: "iteration_master"
      name: "Iterations-Meister"
      description: "Cycle 1 in allen 3 Iterationen abgeschlossen"
      condition: "cycle_01.iterations_completed == 3"
      points: 1000

# =====================================================================
# TRACKING & STATISTIK
# =====================================================================

tracking:
  per_cycle:
    - cycle_id: "cycle_01"
    - iterations_completed: 0
    - current_iteration: 1
    - current_day: 1
    - days_completed: 0
    - total_exercises: 54  # 6 days × 3 exercises × 3 iterations
    - exercises_completed: 0
    - total_points_earned: 0
    - average_score: 0
    - time_spent_seconds: 0

  per_command:
    echo:
      exercises_total: 18  # 3 days × 2 platforms × 3 iterations
      exercises_completed: 0
      average_score: 0
      mastery_level: 0  # 0-100

    grep:
      exercises_total: 18
      exercises_completed: 0
      average_score: 0
      mastery_level: 0

    find:
      exercises_total: 18
      exercises_completed: 0
      average_score: 0
      mastery_level: 0
