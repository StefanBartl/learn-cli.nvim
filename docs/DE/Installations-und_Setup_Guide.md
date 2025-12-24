# 🚀 Installation & Setup Guide - learn-cli.nvim

## Table of content

  - [📋 Voraussetzungen](#voraussetzungen)
  - [1️⃣ Installation](#1-installation)
    - [Mit Lazy.nvim](#mit-lazynvim)
    - [Mit Packer](#mit-packer)
    - [Manuell](#manuell)
  - [2️⃣ Verzeichnisstruktur erstellen](#2-verzeichnisstruktur-erstellen)
  - [3️⃣ Cycle 1 einrichten (Beispiel)](#3-cycle-1-einrichten-beispiel)
    - [Struktur erstellen](#struktur-erstellen)
    - [Metadata erstellen](#metadata-erstellen)
    - [Exercise erstellen](#exercise-erstellen)
    - [Info-Einheit erstellen](#info-einheit-erstellen)
  - [🎯 Lernziele](#lernziele)
  - [📖 Befehlsübersicht](#befehlsbersicht)
    - [Echo - Output und Redirects](#echo-output-und-redirects)
  - [🎮 Übungsstruktur](#bungsstruktur)
  - [📖 Weiterführende Literatur](#weiterfhrende-literatur)
    - [Bücher](#bcher)
    - [Online-Ressourcen](#online-ressourcen)
    - [Man Pages](#man-pages)
  - [4️⃣ Module-Dateien erstellen](#4-module-dateien-erstellen)
  - [5️⃣ Dependencies](#5-dependencies)
    - [Optional: YAML Parser](#optional-yaml-parser)
  - [6️⃣ Testing](#6-testing)
    - [Teste Installation](#teste-installation)
    - [Teste Exercise](#teste-exercise)
    - [Commands testen](#commands-testen)
  - [7️⃣ Keymaps](#7-keymaps)
  - [8️⃣ Troubleshooting](#8-troubleshooting)
    - [Problem: "Cycle nicht gefunden"](#problem-cycle-nicht-gefunden)
    - [Problem: "YAML Parse Error"](#problem-yaml-parse-error)
    - [Problem: "Exercise konnte nicht geladen werden"](#problem-exercise-konnte-nicht-geladen-werden)
    - [Problem: "Validation schlägt fehl obwohl Lösung korrekt"](#problem-validation-schlgt-fehl-obwohl-lsung-korrekt)
  - [9️⃣ Nächste Schritte](#9-nchste-schritte)
  - [🔧 Advanced Configuration](#advanced-configuration)
  - [📚 Weiterführende Dokumentation](#weiterfhrende-dokumentation)

---

## 📋 Voraussetzungen

- Neovim >= 0.9.0
- Lua 5.1+
- Git

## 1️⃣ Installation

### Mit Lazy.nvim

```lua
-- in ~/.config/nvim/lua/plugins/learn-cli.lua
return {
  "lavalue/learn-cli.nvim",
  config = function()
    require("learn_cli").setup({
      -- Optional: Custom config
      auto_save_progress = true,
      show_notifications = true,
      working_dir_base = "/tmp/learn-cli",
    })
  end,
  -- Optional: Lazy loading
  cmd = {
    "LearnCli",
    "LearnCliContinue",
    "LearnCliSubmit",
    "LearnCliHint",
    "LearnCliSolution",
    "LearnCliQuit",
    "LearnCliProgress",
  },
}
```

### Mit Packer

```lua
use {
  "lavalue/learn-cli.nvim",
  config = function()
    require("learn_cli").setup()
  end
}
```

### Manuell

```bash
cd ~/.config/nvim
git clone https://github.com/lavalue/learn-cli.nvim.git lua/learn_cli
```

Dann in `init.lua`:
```lua
require("learn_cli").setup()
```

## 2️⃣ Verzeichnisstruktur erstellen

```bash
# Exercises Verzeichnis
mkdir -p ~/.config/nvim/exercises/cycles

# Docs Verzeichnis
mkdir -p ~/.config/nvim/docs/cycles

# References
mkdir -p ~/.config/nvim/docs/references/commands
```

## 3️⃣ Cycle 1 einrichten (Beispiel)

### Struktur erstellen

```bash
cd ~/.config/nvim

# Cycle 1 Verzeichnisse
mkdir -p exercises/cycles/cycle_01/iteration_1/day_{01..06}
mkdir -p docs/cycles/cycle_01/iteration_1
```

### Metadata erstellen

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
```
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
### Exercise erstellen

**Datei**: `exercises/cycles/cycle_01/iteration_1/day_01/exercises.yaml`

```yaml
day_id: "day_01"
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
  - id: "ex_01_01_redirect"
    title: "Redirect und Append"
    duration: "5min"
    difficulty: 1
    points_max: 100
    tags: ["echo", "redirect"]

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
        viewed_solution: -50

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
        type: "solution"
        text: |
          Lösung:
          echo "hello world" > out.txt
          echo "second line" >> out.txt

    feedback:
      success:
        perfect: "🎉 Perfekt! Du hast beide Redirections korrekt verwendet."
        with_hints: "✅ Geschafft mit Hints! Nächstes Mal ohne?"

      errors:
        file_missing: "❌ Datei nicht gefunden. Hast du '>' verwendet?"
        content_wrong: "❌ Inhalt stimmt nicht. Prüfe ob du '>>' für Zeile 2 benutzt hast."

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

    solution:
      primary: "cat input.txt | tee copy.txt"

    validation:
      type: "file_content"
      file: "copy.txt"
      expected_from_file: "input.txt"

    scoring:
      correct: 100
      time_bonus:
        30s: 20
      hint_penalty:
        1: -10
        2: -20
        3: -30

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

  - id: "ex_01_03_variables"
    title: "Variablenexpansion"
    duration: "5min"
    difficulty: 2
    points_max: 100
    tags: ["echo", "variables"]

    task:
      description: |
        Erstelle Variable NAME="DeinName"
        Gib "Hello $NAME" aus
        Speichere in greeting.txt

    solution:
      primary: |
        NAME="Stefan"
        echo "Hello $NAME" > greeting.txt

    validation:
      type: "pattern"
      file: "greeting.txt"
      regex: "^Hello \\w+$"
      forbidden_literal: "$NAME"

    scoring:
      correct: 100
      time_bonus:
        30s: 20
      hint_penalty:
        1: -10
        2: -20
        3: -30

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
```

### Info-Einheit erstellen

**Datei**: `docs/cycles/cycle_01/iteration_1/info_a.md`

```markdown
# Echo, Grep, Find - Grundlagen

## 🎯 Lernziele
- Output-Redirection verstehen
- Textsuche mit Mustern
- Dateisystem durchsuchen

## 📖 Befehlsübersicht

### Echo - Output und Redirects

**Grundfunktion**: Text ausgeben

**Wichtigste Flags/Operatoren**:
- `>` - Output in Datei schreiben (überschreiben)
- `>>` - Output an Datei anhängen
- `|` - Output an nächsten Befehl weiterleiten
- `$VAR` - Variable expandieren

**Beispiele**:
```bash
# Text in Datei schreiben
echo "hello world" > output.txt

# Text anhängen
echo "zweite Zeile" >> output.txt

# Variable nutzen
NAME="Max"
echo "Hallo $NAME"

# Pipe mit tee
echo "test" | tee datei.txt
```

**Häufige Fehler**:
- ❌ `echo text > file1 > file2` - funktioniert nicht wie erwartet
- ✅ `echo text | tee file1 > file2` - korrekt

**Praxis-Tipps**:
- Nutze `>>` wenn du anhängen willst
- Nutze `>` wenn du überschreiben willst
- `tee` ist nützlich für Output auf Screen UND Datei

---

## 🎮 Übungsstruktur

In den nächsten 3 Tagen wirst du:
- **Tag 1**: Echo-Basics, Redirects, Variables
- **Tag 2**: Grep-Patterns, Flags, Regex
- **Tag 3**: Find-Queries, Filters, Exec

Pro Tag: 3 Exercises à ~5 Minuten

**Tipps**:
- Versuche erst ohne Hints
- Lies Fehlermeldungen genau
- Bei Unsicherheit: Hint nehmen ist OK!

---

## 📖 Weiterführende Literatur

### Bücher
- "The Linux Command Line" by William Shotts
  - Kapitel 6: Redirection

### Online-Ressourcen
- [Bash Redirections Cheat Sheet](https://catonmat.net/bash-one-liners-explained-part-three)

### Man Pages
```bash
man echo
man bash
```

---

**Bereit? Dann starte mit Tag 1!**
```

## 4️⃣ Module-Dateien erstellen

Basierend auf den Artifacts müssen folgende Dateien erstellt werden:

```bash
cd ~/.config/nvim/lua/learn_cli

# Core Module
touch core/cycle_manager.lua
touch core/exercise_runner.lua
touch core/validator.lua
touch core/scorer.lua

# State Module
touch state/progress.lua

# Utils
touch utils/notify.lua
touch utils/yaml_parser.lua

# UI Module
touch ui/dashboard.lua
touch ui/exercise_view.lua
touch ui/info_reader.lua

# User Actions
touch user_actions/commands.lua
touch user_actions/keymaps.lua

# Types
touch @types/init.lua
```

**Kopiere den Code aus den Artifacts in die entsprechenden Dateien!**

## 5️⃣ Dependencies

### Optional: YAML Parser

Für bessere YAML-Unterstützung installiere `lyaml`:

```bash
# Mit LuaRocks
luarocks install lyaml

# Oder System-Package
# Ubuntu/Debian:
sudo apt-get install lua-yaml

# macOS:
brew install lua
luarocks install lyaml
```

**Alternative**: Nutze JSON statt YAML (der Parser unterstützt beides)

```yaml
# Konvertiere YAML zu JSON
exercises/cycles/cycle_01/metadata.json
```

## 6️⃣ Testing

### Teste Installation

```bash
nvim
```

In Neovim:
```vim
:lua require("learn_cli").setup()
:LearnCli
```

Du solltest das Dashboard sehen!

### Teste Exercise

```vim
:LearnCli cycle_01
```

Das erste Exercise sollte starten.

### Commands testen

```vim
" Hint anzeigen
:LearnCliHint

" Lösung einreichen (wenn fertig)
:LearnCliSubmit

" Progress anzeigen
:LearnCliProgress
```

## 7️⃣ Keymaps

Standardmäßig sind folgende Keymaps aktiv während ein Exercise läuft:

| Keymap | Aktion |
|--------|--------|
| `<leader>ls` | Submit solution |
| `<leader>lh` | Show next hint |
| `<leader>lS` | Show solution |
| `<leader>lq` | Quit exercise |
| `<leader>lr` | Refresh exercise view |

**Custom Keymaps** in deiner Config:

```lua
-- in ~/.config/nvim/lua/config/keymaps.lua
vim.keymap.set("n", "<leader>ll", ":LearnCli<CR>", { desc = "Open Learn CLI" })
vim.keymap.set("n", "<leader>lc", ":LearnCliContinue<CR>", { desc = "Continue cycle" })
vim.keymap.set("n", "<leader>lp", ":LearnCliProgress<CR>", { desc = "Show progress" })
```

## 8️⃣ Troubleshooting

### Problem: "Cycle nicht gefunden"

**Lösung**: Prüfe ob `metadata.yaml` existiert:
```bash
ls -la ~/.config/nvim/exercises/cycles/cycle_01/
```

### Problem: "YAML Parse Error"

**Lösung 1**: Installiere `lyaml`
**Lösung 2**: Konvertiere zu JSON

```bash
# YAML zu JSON
cat metadata.yaml | yq -o json > metadata.json
```

### Problem: "Exercise konnte nicht geladen werden"

**Lösung**: Prüfe YAML-Syntax:
```bash
yamllint exercises/cycles/cycle_01/iteration_1/day_01/exercises.yaml
```

### Problem: "Validation schlägt fehl obwohl Lösung korrekt"

**Debug**:
```bash
# Prüfe Working Directory
ls -la /tmp/learn-cli/cycle01/iter1/day01/ex01/

# Prüfe Dateiinhalt
cat /tmp/learn-cli/cycle01/iter1/day01/ex01/out.txt
```

## 9️⃣ Nächste Schritte

1. ✅ Plugin installiert und getestet
2. ✅ Cycle 1 erstellt und funktioniert
3. ⬜ Weitere Days für Cycle 1 erstellen (Tag 2-6)
4. ⬜ Iteration 2 und 3 hinzufügen
5. ⬜ Cycle 2 erstellen
6. ⬜ PowerShell-Äquivalente hinzufügen
7. ⬜ Achievements implementieren

## 🔧 Advanced Configuration

```lua
require("learn_cli").setup({
  -- Working Directory
  working_dir_base = "/tmp/learn-cli",

  -- Auto-save progress after each exercise
  auto_save_progress = true,

  -- Show notifications
  show_notifications = true,

  -- Custom notification handler
  notify_handler = function(msg, level)
    vim.notify(msg, level, { title = "Learn CLI" })
  end,

  -- Custom colors (future feature)
  colors = {
    success = "#50fa7b",
    error = "#ff5555",
    hint = "#f1fa8c",
  },
})
```

## 📚 Weiterführende Dokumentation

- [Lernplan-Vorlage (DE)](./Lernplan-Vorlage-DE.md)
- [Learning Plan Template (EN)](./Learning-Plan-Template-EN.md)
- [Zyklus 1 - Komplett](./Zyklus-1-Komplett.yaml)
- [Content Creation Guide](./Quick-Start-Content-Creation.md)

---

**Fertig! 🎉 Du kannst jetzt mit dem Lernen beginnen:**

```vim
:LearnCli
```
