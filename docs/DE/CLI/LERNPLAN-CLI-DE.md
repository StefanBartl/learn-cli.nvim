# Lernplan-Vorlage für learn-cli.nvim

## Table of content

  - [📋 Metadaten](#metadaten)
  - [🔄 Zyklusstruktur](#zyklusstruktur)
    - [Zyklus 1](#zyklus-1)
    - [Progression über Iterationen](#progression-ber-iterationen)
  - [📚 Info-Einheit Template](#info-einheit-template)
    - [Info-Einheit A (vor Halbzyklus A)](#info-einheit-a-vor-halbzyklus-a)
      - [Struktur der Info-Datei](#struktur-der-info-datei)
  - [🎯 Lernziele dieser Einheit](#lernziele-dieser-einheit)
  - [📖 Befehlsübersicht](#befehlsbersicht)
    - [Echo - Output und Redirects](#echo-output-und-redirects)
    - [Grep - Text durchsuchen](#grep-text-durchsuchen)
    - [Find - Dateien finden](#find-dateien-finden)
  - [🎮 Übungsstruktur](#bungsstruktur)
  - [📖 Weiterführende Literatur](#weiterfhrende-literatur)
    - [Bücher](#bcher)
    - [Online-Ressourcen](#online-ressourcen)
    - [Man Pages](#man-pages)
    - [Interaktive Tutorials](#interaktive-tutorials)
  - [🔖 Cheat Sheet](#cheat-sheet)
    - [Quick Reference](#quick-reference)
  - [🎯 Exercise Template (Detailliert)](#exercise-template-detailliert)
    - [Tag 1 - Programm A1: Echo Basics](#tag-1-programm-a1-echo-basics)
      - [Exercise 1: Redirect und Append](#exercise-1-redirect-und-append)
      - [Exercise 2: Tee mit Pipe](#exercise-2-tee-mit-pipe)
      - [Exercise 3: Variablenexpansion](#exercise-3-variablenexpansion)
  - [📊 Progress Tracking](#progress-tracking)
  - [🏆 Gamification Elements](#gamification-elements)
  - [📈 Statistiken & Reporting](#statistiken-reporting)
  - [🗂️ Dateistruktur im Plugin](#dateistruktur-im-plugin)
  - [🚀 Implementierungs-Hinweise](#implementierungs-hinweise)
    - [Phase 1: Core System](#phase-1-core-system)
    - [Phase 2: Gamification](#phase-2-gamification)
    - [Phase 3: UI](#phase-3-ui)
    - [Phase 4: Content](#phase-4-content)
  - [📝 Notizen für Content-Ersteller](#notizen-fr-content-ersteller)
    - [Do's](#dos)
    - [Don'ts](#donts)
    - [Best Practices](#best-practices)

---

## 📋 Metadaten

```yaml
lernplan_id: "cli_cycle_01"
titel: "CLI Grundlagen - Zyklus 1"
kategorie: "basics" # basics, intermediate, advanced, expert
version: "1.0.0"
plattform: ["linux", "macos"] # linux, macos, windows, powershell
erstellt_am: "2025-01-01"
autor: "Dein Name"
sprache: "de"

# Zeitplanung
zyklen_gesamt: 2
wiederholungen_pro_zyklus: 3
tage_pro_zyklus: 6
dauer_pro_tag: "15min"
dauer_pro_exercise: "5min"
geschätzte_gesamtdauer: "108min" # 2 Zyklen × 3 Wiederholungen × 6 Tage × 15min = 540min

# Voraussetzungen
voraussetzungen:
  technisch:
    - "Installiertes Terminal (Bash/Zsh)"
    - "Neovim >= 0.9.0"
    - "Grundlegende Tastatur-Kenntnisse"
  wissen:
    - "Was ist ein Terminal"
    - "Wie öffne ich ein Terminal"

# Lernziele
lernziele:
  - "Sichere Beherrschung von echo, grep, find"
  - "Verständnis wichtigster Flags und Optionen"
  - "Praktische Anwendung in realen Szenarien"
  - "PowerShell-Äquivalente kennenlernen"

# Bewertungssystem
bewertung:
  punkte_pro_exercise: 100
  bonus_geschwindigkeit: 20
  malus_pro_hint: 10
  passing_score: 60 # mindestens 60% für "bestanden"

# Gamification
achievements:
  - id: "first_blood"
    name: "Erste Schritte"
    beschreibung: "Erste Exercise abgeschlossen"
    punkte: 50
  - id: "perfect_day"
    name: "Perfekter Tag"
    beschreibung: "Alle 3 Exercises eines Tages mit 100% gelöst"
    punkte: 200
  - id: "speed_demon"
    name: "Geschwindigkeitsrausch"
    beschreibung: "5 Exercises unter 30 Sekunden gelöst"
    punkte: 150
  - id: "no_hints"
    name: "Autodidakt"
    beschreibung: "10 Exercises ohne Hints gelöst"
    punkte: 300
```

---

## 🔄 Zyklusstruktur

### Zyklus 1

```yaml
zyklus_id: "cycle_01"
iteration: 1 # 1, 2, oder 3
schwierigkeitsgrad: "basic" # basic, intermediate, advanced

halbzyklus_a:
  tag: [1, 2, 3]
  plattform: ["linux", "macos"]
  programme:
    - name: "echo"
      schwerpunkt: "Output, Redirects, Variables"
    - name: "grep"
      schwerpunkt: "Text Search, Patterns"
    - name: "find"
      schwerpunkt: "File Search, Filters"

halbzyklus_b:
  tag: [4, 5, 6]
  plattform: ["powershell"]
  programme:
    - name: "Write-Output / Out-File"
      äquivalent_zu: "echo"
    - name: "Select-String"
      äquivalent_zu: "grep"
    - name: "Get-ChildItem"
      äquivalent_zu: "find"
```

### Progression über Iterationen

```yaml
iteration_1:
  flags: ["grundlegend", "häufig"]
  komplexität: "einfach"
  beispiele:
    echo: [">", ">>", "$VAR"]
    grep: ["pattern", "-v", "-n"]
    find: ["-name", "-type"]

iteration_2:
  flags: ["erweitert", "kombinationen"]
  komplexität: "mittel"
  beispiele:
    echo: ["|", "tee", "multiple redirects"]
    grep: ["-i", "-r", "regex"]
    find: ["-size", "-mtime", "-exec"]

iteration_3:
  flags: ["komplex", "edge cases"]
  komplexität: "fortgeschritten"
  beispiele:
    echo: ["quoting", "escape sequences", "process substitution"]
    grep: ["-A", "-B", "-C", "--color"]
    find: ["-prune", "-delete", "complex expressions"]
```

---

## 📚 Info-Einheit Template

### Info-Einheit A (vor Halbzyklus A)

```yaml
info_id: "info_cycle01_half_a_iter1"
titel: "Einführung: echo, grep, find"
dauer: "5-10min"
typ: "reading"
pfad: "docs/cycles/cycle_01/iteration_1/info_a.md"
```

#### Struktur der Info-Datei

```markdown
# Echo, Grep, Find - Grundlagen

## 🎯 Lernziele dieser Einheit
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

### Grep - Text durchsuchen

**Grundfunktion**: Zeilen finden, die ein Muster enthalten

**Wichtigste Flags**:
- `-v` - invertiert (Zeilen OHNE Muster)
- `-n` - Zeilennummern anzeigen
- `-i` - Groß-/Kleinschreibung ignorieren
- `-r` - rekursiv in Verzeichnissen

**Beispiele**:
```bash
# Einfache Suche
grep "error" logfile.txt

# Mit Zeilennummern
grep -n "warning" logfile.txt

# Invertiert
grep -v "debug" logfile.txt

# Regex
grep -E 'error|warning' logfile.txt
```

**Häufige Fehler**:
- ❌ Vergessen, dass grep POSIX-Regex nutzt
- ❌ Keine Quotes um Patterns mit Sonderzeichen

---

### Find - Dateien finden

**Grundfunktion**: Dateisystem nach Kriterien durchsuchen

**Wichtigste Flags**:
- `-name "pattern"` - Name (mit Wildcards)
- `-type f` - nur Dateien
- `-type d` - nur Verzeichnisse
- `-size +1M` - Größenfilter
- `-exec cmd {} \;` - Befehl auf jedes Ergebnis

**Beispiele**:
```bash
# Alle .txt Dateien
find . -name "*.txt"

# Nur Dateien, nicht Verzeichnisse
find . -type f -name "*.log"

# Mit exec
find . -name "*.tmp" -exec rm {} \;
```

**Häufige Fehler**:
- ❌ Vergessen von `-type` führt zu Verzeichnissen in Ergebnissen
- ❌ `*` ohne Quotes kann vom Shell expandiert werden

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
  - Kapitel 17: Searching for Files

### Online-Ressourcen
- [GNU Grep Manual](https://www.gnu.org/software/grep/manual/)
- [Find Command Examples](https://www.tecmint.com/35-practical-examples-of-linux-find-command/)
- [Bash Redirections Cheat Sheet](https://catonmat.net/bash-one-liners-explained-part-three)

### Man Pages
```bash
man echo
man grep
man find
```

### Interaktive Tutorials
- [explainshell.com](https://explainshell.com/) - Befehle erklärt
- [Regex101](https://regex101.com/) - Regex testen

---

## 🔖 Cheat Sheet

### Quick Reference

| Befehl | Funktion | Beispiel |
|--------|----------|----------|
| `echo "text" > file` | Überschreiben | `echo "neu" > out.txt` |
| `echo "text" >> file` | Anhängen | `echo "mehr" >> out.txt` |
| `grep pattern file` | Suchen | `grep "error" log.txt` |
| `grep -v pattern file` | Invertiert | `grep -v "info" log.txt` |
| `find . -name "*.txt"` | Nach Name | `find ~ -name "*.pdf"` |
| `find . -type f` | Nur Dateien | `find /var -type f` |

---

**Bereit? Dann starte mit Tag 1!**
```

---

## 🎯 Exercise Template (Detailliert)

### Tag 1 - Programm A1: Echo Basics

```yaml
tag_id: "day_01"
programm_id: "A1_echo_basics"
halbzyklus: "A"
iteration: 1
datum: "2025-01-01"
exercises: 3
gesamtdauer: "15min"

# Setup für alle Exercises dieses Tages
setup:
  arbeitsverzeichnis: "/tmp/learn-cli/cycle01/day01"
  benötigte_dateien:
    - name: "input.txt"
      inhalt: |
        alpha
        beta
        gamma
  cleanup_nach_tag: true
```

---

#### Exercise 1: Redirect und Append

```yaml
exercise_id: "ex_01_01_redirect"
titel: "Text umleiten und anhängen"
dauer: "5min"
schwierigkeit: 1  # Skala 1-10
tags: ["redirect", "append", "basics"]
punkte_max: 100

# Aufgabenstellung
aufgabe:
  beschreibung: |
    Schreibe den Text "hello world" in die Datei `out.txt`.
    Hänge danach den Text "second line" an dieselbe Datei an.

  ziel: |
    Die Datei `out.txt` soll folgendes enthalten:
    hello world
    second line

  hinweise_vor_start:
    - "Nutze '>' um zu überschreiben"
    - "Nutze '>>' um anzuhängen"

# Musterlösung
lösung:
  primäre_lösung: |
    echo "hello world" > out.txt
    echo "second line" >> out.txt

  alternative_lösungen:
    - |
      echo "hello world" > out.txt; echo "second line" >> out.txt
    - |
      echo -e "hello world\nsecond line" > out.txt

# Validierung
validierung:
  typ: "file_content"
  datei: "out.txt"
  erwarteter_inhalt: |
    hello world
    second line

  zusätzliche_checks:
    - typ: "file_exists"
      datei: "out.txt"
    - typ: "line_count"
      datei: "out.txt"
      erwartet: 2
    - typ: "encoding"
      datei: "out.txt"
      erwartet: "utf-8"

# Bewertung
bewertung:
  vollständig_korrekt: 100
  datei_existiert_inhalt_falsch: 40
  nur_eine_zeile: 50
  falsche_reihenfolge: 30

  zeit_bonus:
    unter_30s: 20
    unter_60s: 10
    unter_90s: 5

  hint_malus:
    hint_1: -10
    hint_2: -20
    hint_3: -30
    lösung_angeschaut: -50

# Hints (progressiv)
hints:
  - level: 1
    kosten: 10
    typ: "concept"
    text: |
      Du brauchst zwei Befehle:
      1. Einen zum Schreiben (überschreiben)
      2. Einen zum Anhängen

  - level: 2
    kosten: 20
    typ: "syntax"
    text: |
      Syntax für Redirection:
      echo "TEXT" > DATEI    # überschreiben
      echo "TEXT" >> DATEI   # anhängen

  - level: 3
    kosten: 30
    typ: "partial_solution"
    text: |
      Erster Befehl:
      echo "hello world" > out.txt

      Jetzt noch die zweite Zeile anhängen...

  - level: 4
    kosten: 50
    typ: "full_solution"
    text: |
      Vollständige Lösung:
      echo "hello world" > out.txt
      echo "second line" >> out.txt

# Hilfreiche Informationen
info:
  relevante_man_pages:
    - "man echo"
    - "man bash" # Section über Redirection

  relevante_docs:
    - pfad: "docs/references/redirection.md"
      abschnitt: "Basic Output Redirection"

  verwandte_exercises:
    - "ex_01_02_tee_pipe"
    - "ex_02_01_grep_redirect"

  häufige_fehler:
    - fehler: "Beide Male '>' verwendet"
      erklärung: "Das zweite '>' überschreibt die Datei komplett"
      lösung: "Nutze '>>' für das Anhängen"

    - fehler: "Keine Quotes um Text"
      erklärung: "Bei Leerzeichen ist das problematisch"
      lösung: "Nutze immer Quotes: echo \"text with spaces\""

# Feedback-Texte
feedback:
  erfolg:
    perfekt: |
      🎉 Perfekt! Du hast beide Redirections korrekt angewendet.

      Du hast verstanden:
      - '>' überschreibt eine Datei
      - '>>' hängt an eine Datei an

      Nächster Schritt: Probiere auch 'tee' aus!

    mit_hints: |
      ✅ Geschafft! Die Hints haben geholfen.

      Merke dir:
      - '>' = neu schreiben
      - '>>' = anhängen

      Beim nächsten Mal versuch es ohne Hints!

  fehler:
    datei_fehlt: |
      ❌ Die Datei 'out.txt' wurde nicht erstellt.

      Prüfe:
      - Hast du den echo-Befehl ausgeführt?
      - Hast du '>' verwendet?

    inhalt_falsch: |
      ❌ Die Datei existiert, aber der Inhalt stimmt nicht.

      Erwartet:
      hello world
      second line

      Gefunden:
      {actual_content}

      Tipp: Prüfe ob du '>>' für die zweite Zeile benutzt hast.
```

---

#### Exercise 2: Tee mit Pipe

```yaml
exercise_id: "ex_01_02_tee_pipe"
titel: "Gleichzeitig anzeigen und speichern"
dauer: "5min"
schwierigkeit: 2
tags: ["pipe", "tee", "intermediate"]
punkte_max: 100

aufgabe:
  beschreibung: |
    Zeige den Inhalt von `input.txt` auf dem Bildschirm an
    UND schreibe ihn gleichzeitig in die Datei `copy.txt`.

    Nutze dafür den Befehl 'tee'.

  vorbedingung:
    - "input.txt muss existieren"

  ziel: |
    - Auf dem Bildschirm sollte erscheinen:
      alpha
      beta
      gamma

    - Die Datei copy.txt sollte denselben Inhalt haben

lösung:
  primäre_lösung: |
    cat input.txt | tee copy.txt

  alternative_lösungen:
    - |
      tee copy.txt < input.txt
    - |
      cat input.txt | tee copy.txt | cat

validierung:
  checks:
    - typ: "file_content"
      datei: "copy.txt"
      erwarteter_inhalt_von: "input.txt"

    - typ: "command_output"
      befehl: "cat copy.txt"
      erwartete_ausgabe: |
        alpha
        beta
        gamma

hints:
  - level: 1
    kosten: 10
    text: |
      Der Befehl 'tee' liest von stdin und schreibt
      sowohl nach stdout als auch in eine Datei.

      Du musst den Inhalt von input.txt zu tee pipen.

  - level: 2
    kosten: 20
    text: |
      Schema: cat QUELLE | tee ZIEL

      tee zeigt auf dem Bildschirm UND schreibt in die Datei.

  - level: 3
    kosten: 30
    text: |
      Lösung:
      cat input.txt | tee copy.txt
```

---

#### Exercise 3: Variablenexpansion

```yaml
exercise_id: "ex_01_03_variables"
titel: "Variablen nutzen"
dauer: "5min"
schwierigkeit: 2
tags: ["variables", "expansion"]
punkte_max: 100

aufgabe:
  beschreibung: |
    Erstelle eine Variable NAME mit deinem Namen.
    Gib dann "Hello $NAME" aus.

    Speichere die Ausgabe in der Datei greeting.txt

  ziel: |
    Datei greeting.txt soll enthalten:
    Hello [Dein Name]

    (wobei [Dein Name] der Wert deiner Variable ist)

lösung:
  primäre_lösung: |
    NAME="Stefan"
    echo "Hello $NAME" > greeting.txt

  flexibel: true  # Name kann variieren
  muster: "Hello \\w+"

validierung:
  checks:
    - typ: "file_exists"
      datei: "greeting.txt"

    - typ: "pattern_match"
      datei: "greeting.txt"
      regex: "^Hello \\w+$"

    - typ: "not_literal"
      datei: "greeting.txt"
      verboten: "$NAME"  # Variable muss expandiert sein

hints:
  - level: 1
    kosten: 10
    text: |
      In Bash/Zsh kannst du Variablen so setzen:
      VARNAME="wert"

      Und so nutzen:
      echo "$VARNAME"

  - level: 2
    kosten: 20
    text: |
      Zwei Schritte:
      1. NAME="DeinName"
      2. echo "Hello $NAME" > greeting.txt

  - level: 3
    kosten: 30
    text: |
      Vollständige Lösung:
      NAME="Stefan"
      echo "Hello $NAME" > greeting.txt

      (Du kannst natürlich einen anderen Namen verwenden)
```

---

## 📊 Progress Tracking

```yaml
tracking:
  pro_exercise:
    - start_zeit
    - end_zeit
    - dauer_sekunden
    - hints_benutzt: []
    - versuche: 0
    - erfolg: boolean
    - punkte_erreicht: 0
    - punkte_maximal: 100

  pro_tag:
    - tag_nummer
    - exercises_abgeschlossen: 0
    - exercises_gesamt: 3
    - durchschnitt_punkte: 0
    - durchschnitt_zeit: 0
    - achievements_freigeschaltet: []

  pro_zyklus:
    - zyklus_id
    - iteration: 1
    - fortschritt_prozent: 0
    - tage_abgeschlossen: 0
    - tage_gesamt: 6
    - gesamt_punkte: 0
    - durchschnitt_pro_exercise: 0

  global:
    - level: 1
    - erfahrung_punkte: 0
    - streak: 0  # Tage hintereinander
    - achievements_total: []
    - statistiken:
        exercises_gesamt: 0
        exercises_perfect: 0
        exercises_mit_hints: 0
        durchschnitt_zeit: 0
        schnellste_zeit: 999
        langsamste_zeit: 0
```

---

## 🏆 Gamification Elements

```yaml
achievements:
  # Basics
  - id: "first_steps"
    name: "Erste Schritte"
    beschreibung: "Erste Exercise abgeschlossen"
    bedingung: "exercises_completed >= 1"
    punkte: 50
    icon: "🚀"

  - id: "perfect_score"
    name: "Perfekte Leistung"
    beschreibung: "Eine Exercise mit 100/100 Punkten"
    bedingung: "any(exercise.punkte == 100)"
    punkte: 100
    icon: "💯"

  - id: "perfect_day"
    name: "Perfekter Tag"
    beschreibung: "Alle 3 Exercises eines Tages mit 100/100"
    bedingung: "all_exercises_today == 100"
    punkte: 300
    icon: "⭐"

  # Speed
  - id: "speed_runner"
    name: "Speedrunner"
    beschreibung: "Exercise in unter 30 Sekunden gelöst"
    bedingung: "exercise.dauer < 30"
    punkte: 75
    icon: "⚡"

  - id: "speed_demon"
    name: "Speed Demon"
    beschreibung: "5 Exercises unter 30 Sekunden"
    bedingung: "count(exercise.dauer < 30) >= 5"
    punkte: 200
    icon: "🔥"

  # Learning
  - id: "autodidact"
    name: "Autodidakt"
    beschreibung: "10 Exercises ohne Hints"
    bedingung: "count(exercise.hints == 0) >= 10"
    punkte: 300
    icon: "🧠"

  - id: "persistent"
    name: "Beharrlich"
    beschreibung: "Exercise nach 3+ Versuchen geschafft"
    bedingung: "exercise.versuche >= 3 and exercise.erfolg"
    punkte: 150
    icon: "💪"

  # Progression
  - id: "half_cycle"
    name: "Halbzeit"
    beschreibung: "Ersten Halbzyklus (3 Tage) abgeschlossen"
    bedingung: "days_completed >= 3"
    punkte: 200
    icon: "🎯"

  - id: "full_cycle"
    name: "Voller Zyklus"
    beschreibung: "Einen kompletten Zyklus (6 Tage) abgeschlossen"
    bedingung: "cycle.days_completed == 6"
    punkte: 500
    icon: "🏆"

  - id: "cycle_master"
    name: "Zyklus-Meister"
    beschreibung: "Einen Zyklus 3× wiederholt"
    bedingung: "cycle.iterations >= 3"
    punkte: 1000
    icon: "👑"

  # Streaks
  - id: "three_day_streak"
    name: "Dreitagestreak"
    beschreibung: "3 Tage hintereinander geübt"
    bedingung: "streak >= 3"
    punkte: 150
    icon: "📅"

  - id: "week_warrior"
    name: "Wochenkrieger"
    beschreibung: "7 Tage hintereinander geübt"
    bedingung: "streak >= 7"
    punkte: 500
    icon: "🗓️"

# Leaderboard
leaderboard:
  kategorien:
    - name: "Gesamtpunkte"
      feld: "gesamt_punkte"
      sortierung: "desc"

    - name: "Exercises abgeschlossen"
      feld: "exercises_gesamt"
      sortierung: "desc"

    - name: "Perfekte Scores"
      feld: "exercises_perfect"
      sortierung: "desc"

    - name: "Durchschnittszeit"
      feld: "durchschnitt_zeit"
      sortierung: "asc"

    - name: "Längster Streak"
      feld: "max_streak"
      sortierung: "desc"

# Level System
level_system:
  erfahrung_pro_exercise: 25
  erfahrung_pro_achievement: "achievement.punkte / 10"

  levels:
    - level: 1
      name: "Neuling"
      erfahrung_benötigt: 0
      icon: "🌱"

    - level: 2
      name: "Lernender"
      erfahrung_benötigt: 250
      icon: "📚"

    - level: 3
      name: "Praktizierender"
      erfahrung_benötigt: 750
      icon: "⚙️"

    - level: 4
      name: "Fortgeschrittener"
      erfahrung_benötigt: 1500
      icon: "🎓"

    - level: 5
      name: "Experte"
      erfahrung_benötigt: 3000
      icon: "🌟"

    - level: 6
      name: "Meister"
      erfahrung_benötigt: 5000
      icon: "👑"
```

---

## 📈 Statistiken & Reporting

```yaml
statistiken:
  exercise_level:
    - name: "Durchschnittliche Punktzahl"
      berechnung: "sum(punkte) / count(exercises)"

    - name: "Durchschnittliche Zeit"
      berechnung: "sum(dauer) / count(exercises)"

    - name: "Erfolgsrate"
      berechnung: "(erfolge / versuche) * 100"

    - name: "Hint-Nutzung"
      berechnung: "sum(hints) / count(exercises)"

  tag_level:
    - name: "Beste Exercise"
      berechnung: "max(exercise.punkte)"

    - name: "Schlechteste Exercise"
      berechnung: "min(exercise.punkte)"

    - name: "Trend"
      berechnung: "compare(heute, gestern)"

  zyklus_level:
    - name: "Fortschritt"
      berechnung: "(tage_abgeschlossen / tage_gesamt) * 100"

    - name: "Verbesserung"
      berechnung: "compare(iteration_2, iteration_1)"

  global:
    - name: "Gesamtzeit"
      berechnung: "sum(alle_exercises.dauer)"

    - name: "Häufigste Fehler"
      berechnung: "group_by(fehlertyp).count()"

reports:
  täglicher_report:
    inhalt:
      - "Exercises heute: X/3"
      - "Punkte heute: Y"
      - "Neue Achievements: Z"
      - "Streak: N Tage"
      - "Nächstes Ziel: ..."

  wochen_report:
    inhalt:
      - "Exercises diese Woche: X"
      - "Durchschnittliche Punkte: Y"
      - "Geübte Befehle: echo, grep, find"
      - "Stärken: ..."
      - "Verbesserungspotential: ..."

  zyklus_report:
    inhalt:
      - "Zyklus abgeschlossen: X von 3"
      - "Gesamtfortschritt: Y%"
      - "Beherrschte Befehle: ..."
      - "Nächste Iteration: harder flags"
      - "Empfehlung: ..."
```

---

## 🗂️ Dateistruktur im Plugin

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

## 🚀 Implementierungs-Hinweise

### Phase 1: Core System
1. Exercise Runner (lädt und führt Exercises aus)
2. Validierungssystem (prüft Lösungen)
3. Progress Tracking (speichert Fortschritt)

### Phase 2: Gamification
1. Achievement System
2. Level/XP System
3. Streak Tracking

### Phase 3: UI
1. Dashboard (Überblick)
2. Exercise View (während Exercise)
3. Statistics View (Auswertungen)

### Phase 4: Content
1. Cycle 1 (echo, grep, find)
2. Cycle 2 (exec/read, cp/rm/mv, sh/ssh/tar)
3. PowerShell Äquivalente

---

## 📝 Notizen für Content-Ersteller

### Do's
- ✅ Klare, eindeutige Aufgabenstellungen
- ✅ Realistische Zeitschätzungen (5min)
- ✅ Mehrere Lösungswege akzeptieren
- ✅ Schrittweise Hints (vom Konzept zur Lösung)
- ✅ Häufige Fehler dokumentieren
- ✅ Weiterführende Literatur angeben

### Don'ts
- ❌ Zu komplexe Exercises (keep it simple!)
- ❌ Unklare Erfolgskriterien
- ❌ Hints die zu viel verraten
- ❌ Unrealistische Zeitlimits
- ❌ Plattform-spezifische Befehle ohne Alternative

### Best Practices
1. Teste jede Exercise selbst
2. Validiere alle Musterlösungen
3. Prüfe Hints auf Verständlichkeit
4. Dokumentiere Edge Cases
5. Gib Kontext zu jedem Befehl

---

**Diese Vorlage dient als Grundlage für alle Lernpläne in learn-cli.nvim**
