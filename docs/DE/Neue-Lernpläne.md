# Quick-Start Guide: Neue Lernpläne für learn-cli.nvim erstellen

## Table of content

  - [🎯 Überblick](#berblick)
  - [📁 Schritt 1: Verzeichnisstruktur anlegen](#schritt-1-verzeichnisstruktur-anlegen)
  - [📝 Schritt 2: Metadata erstellen](#schritt-2-metadata-erstellen)
  - [📚 Schritt 3: Info-Einheit schreiben](#schritt-3-info-einheit-schreiben)
    - [Struktur der Info-Einheit](#struktur-der-info-einheit)
  - [🎯 Lernziele](#lernziele)
  - [📖 Befehlsübersicht](#befehlsbersicht)
    - [[Command 1] - [Zweck]](#command-1-zweck)
  - [🎮 Übungsstruktur](#bungsstruktur)
  - [📖 Weiterführende Literatur](#weiterfhrende-literatur)
    - [Bücher](#bcher)
    - [Online-Ressourcen](#online-ressourcen)
    - [Man Pages](#man-pages)
    - [Interaktive Tutorials](#interaktive-tutorials)
  - [🔖 Cheat Sheet](#cheat-sheet)
  - [🎯 Schritt 4: Exercise erstellen](#schritt-4-exercise-erstellen)
    - [Minimales Exercise](#minimales-exercise)
    - [Komplexeres Exercise mit Setup](#komplexeres-exercise-mit-setup)
  - [🧪 Schritt 5: Exercise testen](#schritt-5-exercise-testen)
    - [Manuell testen](#manuell-testen)
    - [Automatisiert testen (empfohlen)](#automatisiert-testen-empfohlen)
  - [📊 Schritt 6: Statistiken und Tracking](#schritt-6-statistiken-und-tracking)
    - [Progress-Daten](#progress-daten)
  - [🏆 Schritt 7: Achievements definieren](#schritt-7-achievements-definieren)
  - [🎨 Schritt 8: UI anpassen (optional)](#schritt-8-ui-anpassen-optional)
    - [Exercise View customizen](#exercise-view-customizen)
  - [🔍 Schritt 9: Content Review Checklist](#schritt-9-content-review-checklist)
    - [Inhaltlich](#inhaltlich)
    - [Technisch](#technisch)
    - [Pädagogisch](#pdagogisch)
    - [Testing](#testing)
  - [📦 Schritt 10: Cycle veröffentlichen](#schritt-10-cycle-verffentlichen)
    - [Git Commit](#git-commit)
    - [Release Notes](#release-notes)
  - [[1.1.0] - 2025-01-15](#110-2025-01-15)
    - [Added](#added)
    - [Documentation](#documentation)
  - [🚀 Bonus: Templates für häufige Szenarien](#bonus-templates-fr-hufige-szenarien)
    - [Template: File-Manipulation Exercise](#template-file-manipulation-exercise)
    - [Template: Command Output Exercise](#template-command-output-exercise)
    - [Template: Pipe Exercise](#template-pipe-exercise)
  - [📞 Support & Fragen](#support-fragen)
  - [🎯 Nächste Schritte](#nchste-schritte)

---

## 🎯 Überblick

Dieser Guide zeigt dir Schritt für Schritt, wie du neue Cycles und Exercises für learn-cli.nvim erstellst.

**Zeitbedarf**: 30-60 Minuten pro Tag (3 Exercises)
**Schwierigkeit**: Mittel (YAML/Markdown-Kenntnisse)

---

## 📁 Schritt 1: Verzeichnisstruktur anlegen

```bash
cd learn-cli.nvim

# Neuen Cycle erstellen
mkdir -p exercises/cycles/cycle_XX
mkdir -p exercises/cycles/cycle_XX/iteration_{1,2,3}

# Pro Iteration: 6 Tage erstellen
for i in 1 2 3; do
  mkdir -p exercises/cycles/cycle_XX/iteration_$i/day_{01..06}
done

# Docs-Struktur
mkdir -p docs/cycles/cycle_XX/iteration_{1,2,3}

# References
mkdir -p docs/references/commands
```

**Beispiel für Cycle 1**:
```
exercises/cycles/cycle_01/
├── metadata.yaml
├── iteration_1/
│   ├── day_01/
│   │   ├── setup.lua
│   │   ├── ex_01.yaml
│   │   ├── ex_02.yaml
│   │   └── ex_03.yaml
│   ├── day_02/
│   ├── day_03/
│   ├── day_04/
│   ├── day_05/
│   └── day_06/
├── iteration_2/
└── iteration_3/

docs/cycles/cycle_01/
├── iteration_1/
│   ├── info_a.md
│   └── info_b.md
├── iteration_2/
└── iteration_3/
```

---

## 📝 Schritt 2: Metadata erstellen

**Datei**: `exercises/cycles/cycle_01/metadata.yaml`

```yaml
metadata:
  cycle_id: "cycle_01"
  title: "CLI Basics: echo, grep, find"
  category: "basics"
  version: "1.0.0"
  platforms: ["linux", "macos"]
  iterations: 3
  days_per_cycle: 6
  duration_per_day: "15min"

  objectives:
    - "Master echo (>, >>, |, tee)"
    - "Use grep for text search"
    - "Find files efficiently"

# Weitere Details siehe Vorlage
```

---

## 📚 Schritt 3: Info-Einheit schreiben

**Datei**: `docs/cycles/cycle_01/iteration_1/info_a.md`

### Struktur der Info-Einheit

```markdown
# [Command-Namen] - Grundlagen

## 🎯 Lernziele
- Was du nach dieser Einheit können wirst

## 📖 Befehlsübersicht

### [Command 1] - [Zweck]

**Grundfunktion**: ...

**Wichtigste Flags**:
- `-flag` - Beschreibung
- `--long-flag` - Beschreibung

**Beispiele**:
```bash
# Beispiel 1
command -flag input.txt

# Beispiel 2
command --long-flag | other-command
```

**Häufige Fehler**:
- ❌ Fehler-Beschreibung
- ✅ Richtige Vorgehensweise

**Praxis-Tipps**:
- Tipp 1
- Tipp 2

---

## 🎮 Übungsstruktur

In den nächsten 3 Tagen:
- **Tag 1**: Thema A
- **Tag 2**: Thema B
- **Tag 3**: Thema C

Pro Tag: 3 Exercises à ~5 Minuten

---

## 📖 Weiterführende Literatur

### Bücher
- Titel, Autor
  - Relevante Kapitel

### Online-Ressourcen
- [Link-Text](URL)

### Man Pages
```bash
man command
```

### Interaktive Tutorials
- [Tutorial-Name](URL)

---

## 🔖 Cheat Sheet

| Befehl | Funktion | Beispiel |
|--------|----------|----------|
| `cmd`  | ...      | `cmd -f` |

---

**Bereit? Dann starte mit Tag 1!**
```

**💡 Tipps**:
- Halte Info-Einheiten kurz (5-10 Minuten Lesezeit)
- Nutze viele Beispiele
- Dokumentiere häufige Fehler
- Gib Kontext zu jedem Befehl

---

## 🎯 Schritt 4: Exercise erstellen

**Datei**: `exercises/cycles/cycle_01/iteration_1/day_01/ex_01.yaml`

### Minimales Exercise

```yaml
id: "ex_01_01_redirect"
title: "Redirect und Append"
duration: "5min"
difficulty: 1
points_max: 100
tags: ["echo", "redirect"]

task:
  description: |
    Schreibe "hello world" in out.txt
    Hänge "second line" an

  expected_result: |
    Datei out.txt:
    hello world
    second line

solution:
  primary: |
    echo "hello world" > out.txt
    echo "second line" >> out.txt

  alternatives:
    - 'echo "hello world" > out.txt; echo "second line" >> out.txt'

validation:
  type: "file_content"
  file: "out.txt"
  expected: |
    hello world
    second line

scoring:
  correct: 100
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
    text: "Du brauchst > zum Überschreiben und >> zum Anhängen"

  - level: 2
    cost: 20
    type: "syntax"
    text: "echo \"TEXT\" > DATEI\necho \"TEXT\" >> DATEI"

  - level: 3
    cost: 30
    type: "solution"
    text: |
      echo "hello world" > out.txt
      echo "second line" >> out.txt

feedback:
  success:
    perfect: "🎉 Perfekt! Du hast es geschafft!"
    with_hints: "✅ Geschafft mit Hints!"

  errors:
    file_missing: "❌ Datei nicht gefunden"
    content_wrong: "❌ Inhalt stimmt nicht"
```

### Komplexeres Exercise mit Setup

```yaml
id: "ex_03_01_find"
title: "Find mit -name und -type"
duration: "5min"
difficulty: 2
points_max: 100

# Setup wird vor Exercise ausgeführt
setup:
  working_dir: "/tmp/learn-cli/cycle01/iter1/day03/ex01"
  structure:
    - "test-dir/"
    - "test-dir/file1.txt"
    - "test-dir/file2.log"
    - "test-dir/sub/"
    - "test-dir/sub/file3.txt"
  cleanup: true  # Nach Exercise aufräumen

task:
  description: |
    Finde alle .txt Dateien in test-dir/
    Nutze -type f für nur Dateien
    Nutze -name für Pattern

  expected_output: |
    test-dir/file1.txt
    test-dir/sub/file3.txt

solution:
  primary: 'find test-dir -type f -name "*.txt"'

validation:
  type: "command_output_unordered"
  command: 'find test-dir -type f -name "*.txt"'
  expected_lines:
    - "test-dir/file1.txt"
    - "test-dir/sub/file3.txt"

# Rest wie oben...
```

---

## 🧪 Schritt 5: Exercise testen

### Manuell testen

```bash
cd learn-cli.nvim

# Exercise-Datei laden
nvim exercises/cycles/cycle_01/iteration_1/day_01/ex_01.yaml

# In Neovim: Plugin laden
:lua require('learn_cli').start_cycle('cycle_01')

# Exercise durchführen
# Lösung einreichen
:LearnCliSubmit

# Hints testen
:LearnCliHint 1
:LearnCliHint 2

# Lösung anzeigen
:LearnCliSolution
```

### Automatisiert testen (empfohlen)

**Datei**: `tests/exercises/test_cycle_01.lua`

```lua
local validator = require("learn_cli.core.validator")

describe("Cycle 01 - Day 01", function()
  describe("Exercise 01 - Redirect", function()
    local working_dir = "/tmp/test-learn-cli/cycle01/day01/ex01"

    before_each(function()
      vim.fn.mkdir(working_dir, "p")
      vim.fn.chdir(working_dir)
    end)

    after_each(function()
      vim.fn.delete(working_dir, "rf")
    end)

    it("sollte Datei mit korrektem Inhalt erstellen", function()
      -- Setup
      vim.fn.system('echo "hello world" > out.txt')
      vim.fn.system('echo "second line" >> out.txt')

      -- Validation
      local validation = {
        type = "file_content",
        file = "out.txt",
        expected = "hello world\nsecond line"
      }

      local result = validator.validate(validation, working_dir)

      assert.is_true(result.success)
      assert.equals(0, #result.errors)
    end)

    it("sollte Fehler bei falschem Inhalt geben", function()
      vim.fn.system('echo "wrong" > out.txt')

      local validation = {
        type = "file_content",
        file = "out.txt",
        expected = "hello world\nsecond line"
      }

      local result = validator.validate(validation, working_dir)

      assert.is_false(result.success)
      assert.is_true(#result.errors > 0)
    end)
  end)
end)
```

**Tests ausführen**:
```bash
# Mit busted
busted tests/exercises/test_cycle_01.lua

# Oder mit plenary.nvim
nvim --headless -c "PlenaryBustedDirectory tests/exercises/ {minimal_init = 'tests/minimal_init.lua'}"
```

---

## 📊 Schritt 6: Statistiken und Tracking

### Progress-Daten

Das Plugin speichert automatisch:
```json
{
  "cycles": {
    "cycle_01": {
      "current_iteration": 1,
      "current_day": 2,
      "current_exercise": 3,
      "completed": false
    }
  },
  "exercises": [
    {
      "exercise_id": "ex_01_01_redirect",
      "duration": 45,
      "attempts": 1,
      "hints_used": 0,
      "score": {
        "total": 120,
        "max": 100,
        "percentage": 120,
        "time_bonus": 20
      },
      "timestamp": 1735234567
    }
  ],
  "statistics": {
    "total_time": 450,
    "exercises_completed": 10,
    "perfect_scores": 5,
    "streak": 3,
    "last_activity": "2025-01-15"
  },
  "level": 2,
  "xp": 275
}
```

---

## 🏆 Schritt 7: Achievements definieren

**Datei**: `lua/learn_cli/gamification/achievements/cycle_01.lua`

```lua
return {
  {
    id = "echo_master",
    name = "Echo Meister",
    description = "Alle echo Exercises mit 100% abgeschlossen",
    icon = "🔊",
    points = 200,
    condition = function(data)
      local echo_exercises = vim.tbl_filter(function(ex)
        return vim.startswith(ex.exercise_id, "ex_01") or
               vim.startswith(ex.exercise_id, "ex_04")
      end, data.exercises)

      local all_perfect = vim.tbl_count(echo_exercises) > 0 and
        vim.tbl_count(vim.tbl_filter(function(ex)
          return ex.score.percentage == 100
        end, echo_exercises)) == vim.tbl_count(echo_exercises)

      return all_perfect
    end,
  },
  {
    id = "cycle_01_complete",
    name = "Cycle 1 Abgeschlossen",
    description = "Alle 6 Tage von Cycle 1 abgeschlossen",
    icon = "🎯",
    points = 500,
    condition = function(data)
      local cycle = data.cycles.cycle_01
      return cycle and cycle.current_day > 6
    end,
  },
}
```

---

## 🎨 Schritt 8: UI anpassen (optional)

### Exercise View customizen

**Datei**: `lua/learn_cli/ui/themes/custom.lua`

```lua
return {
  colors = {
    success = "#50fa7b",
    error = "#ff5555",
    hint = "#f1fa8c",
    info = "#8be9fd",
  },

  icons = {
    exercise = "📝",
    hint = "💡",
    solution = "🔑",
    success = "✅",
    error = "❌",
    timer = "⏱️",
  },

  formatting = {
    title_style = "bold",
    code_highlight = "Comment",
  },
}
```

---

## 🔍 Schritt 9: Content Review Checklist

Bevor du einen Cycle veröffentlichst, prüfe:

### Inhaltlich
- [ ] Alle Befehle sind korrekt dokumentiert
- [ ] Beispiele funktionieren wie beschrieben
- [ ] Häufige Fehler sind dokumentiert
- [ ] Literaturangaben sind aktuell und verfügbar

### Technisch
- [ ] Alle YAML-Dateien sind valide
- [ ] Validierungen funktionieren korrekt
- [ ] Hints sind progressiv und hilfreich
- [ ] Setup/Cleanup funktioniert

### Pädagogisch
- [ ] Schwierigkeitsgrad passt zur Iteration
- [ ] Zeitschätzungen sind realistisch
- [ ] Progression ist logisch aufgebaut
- [ ] Feedback ist konstruktiv und motivierend

### Testing
- [ ] Alle Musterlösungen getestet
- [ ] Alternative Lösungen validiert
- [ ] Edge Cases abgedeckt
- [ ] Performance ist akzeptabel

---

## 📦 Schritt 10: Cycle veröffentlichen

### Git Commit

```bash
# Änderungen hinzufügen
git add exercises/cycles/cycle_01/
git add docs/cycles/cycle_01/
git add docs/references/commands/

# Commit mit aussagekräftiger Message
git commit -m "feat: Add Cycle 1 - echo, grep, find

- 6 days with 3 exercises each
- 3 iterations (basic, intermediate, advanced)
- Linux/macOS + PowerShell versions
- Full documentation and references
- Achievement integration"

# Push
git push origin main
```

### Release Notes

**Datei**: `CHANGELOG.md`

```markdown
## [1.1.0] - 2025-01-15

### Added
- **Cycle 1: CLI Basics (echo, grep, find)**
  - 18 exercises across 6 days
  - 3 difficulty iterations
  - PowerShell equivalents
  - Comprehensive documentation
  - New achievements: Echo Master, Grep Guru, Find Expert

### Documentation
- Added reference docs for echo, grep, find
- New beginner guides
- Cheat sheets for quick reference
```

---

## 🚀 Bonus: Templates für häufige Szenarien

### Template: File-Manipulation Exercise

```yaml
id: "ex_XX_YY_file_ops"
title: "Datei-Operationen"
difficulty: 2
points_max: 100

setup:
  files:
    - name: "source.txt"
      content: "original content"

task:
  description: "Kopiere source.txt nach dest.txt"

solution:
  primary: "cp source.txt dest.txt"

validation:
  type: "multi"
  checks:
    - type: "file_exists"
      file: "dest.txt"
    - type: "file_content"
      file: "dest.txt"
      expected_from_file: "source.txt"
```

### Template: Command Output Exercise

```yaml
id: "ex_XX_YY_output"
title: "Command Output"
difficulty: 2
points_max: 100

task:
  description: "Liste alle Dateien im aktuellen Verzeichnis"

solution:
  primary: "ls"

validation:
  type: "command_success"
  command: "ls"
  must_contain: ["file1.txt", "file2.txt"]
```

### Template: Pipe Exercise

```yaml
id: "ex_XX_YY_pipe"
title: "Pipe Kombination"
difficulty: 3
points_max: 150

task:
  description: "Finde Zeilen mit 'error' und zähle sie"

solution:
  primary: "grep error log.txt | wc -l"

validation:
  type: "command_output"
  command: "grep error log.txt | wc -l"
  expected: "3"
```

---

## 📞 Support & Fragen

- **Dokumentation**: [docs/README.md](../README.md)
- **Issues**: [GitHub Issues](https://github.com/yourusername/learn-cli.nvim/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/learn-cli.nvim/discussions)

---

## 🎯 Nächste Schritte

1. ✅ Lies beide Vorlagen (DE + EN)
2. ✅ Studiere Cycle 1 als Referenz
3. ✅ Erstelle deinen ersten Test-Exercise
4. ✅ Teste ihn gründlich
5. ✅ Erweitere zu einem vollständigen Tag
6. ✅ Baue den kompletten Cycle auf
7. ✅ Teile ihn mit der Community!

**Viel Erfolg beim Erstellen großartiger Lernpläne! 🚀**
