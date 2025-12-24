# Lernplan-Vorlage für learn-cli.nvim

## Table of content

  - [Metadaten](#metadaten)
  - [Zyklusstruktur](#zyklusstruktur)
    - [Übersicht](#bersicht)
    - [Progression](#progression)
  - [Halbzyklus A (Tag 1-3)](#halbzyklus-a-tag-1-3)
    - [Info-Einheit A (vor Tag 1)](#info-einheit-a-vor-tag-1)
      - [Inhalt der Info-Einheit](#inhalt-der-info-einheit)
    - [Tag 1: Programm A1](#tag-1-programm-a1)
      - [Exercise 1: "Navigation Basics"](#exercise-1-navigation-basics)
      - [Exercise 2: "Flag Kombination"](#exercise-2-flag-kombination)
      - [Exercise 3: "Verzeichnis-Navigation"](#exercise-3-verzeichnis-navigation)
    - [Tag 2: Programm A2](#tag-2-programm-a2)
    - [Tag 3: Programm A3](#tag-3-programm-a3)
  - [Halbzyklus B (Tag 4-6)](#halbzyklus-b-tag-4-6)
    - [Info-Einheit B (vor Tag 4)](#info-einheit-b-vor-tag-4)
    - [Tag 4: Programm B1](#tag-4-programm-b1)
    - [Tag 5: Programm B2](#tag-5-programm-b2)
    - [Tag 6: Programm B3](#tag-6-programm-b3)
  - [Wiederholungen](#wiederholungen)
    - [Zyklus 2 (Tag 7-12)](#zyklus-2-tag-7-12)

---

## Metadaten

```yaml
lernplan_id: "cli_basics_01"
titel: "CLI Grundlagen - Dateioperationen"
version: "1.0.0"
schwierigkeitsgrad: "beginner" # beginner, intermediate, advanced, expert
erstellt_am: "2025-01-01"
autor: "Max Mustermann"
sprache: "de"
geschätzte_gesamtdauer: "90min" # 6 Tage × 15min
voraussetzungen:
  - "Grundlegende Terminal-Kenntnisse"
  - "Neovim installiert"
lernziele:
  - "Sichere Beherrschung grundlegender CLI-Befehle"
  - "Verständnis von Flags und Optionen"
  - "Effiziente Navigation im Dateisystem"
```

---

## Zyklusstruktur

### Übersicht
- **Zyklusdauer**: 6 Tage
- **Wiederholungen**: 3× (insgesamt 18 Tage)
- **Halbzyklus A**: Tag 1-3 (Programme A1, A2, A3)
- **Halbzyklus B**: Tag 4-6 (Programme B1, B2, B3)
- **Tägliche Dauer**: ~15 Minuten (3 Exercises à 5 Minuten)

### Progression
```yaml
zyklus_1:
  schwierigkeitsgrad: "basic"
  flags: ["grundlegende", "häufige"]
  komplexität: "niedrig"

zyklus_2:
  schwierigkeitsgrad: "intermediate"
  flags: ["erweiterte", "kombinationen"]
  komplexität: "mittel"

zyklus_3:
  schwierigkeitsgrad: "advanced"
  flags: ["komplexe", "edge-cases"]
  komplexität: "hoch"
```

---

## Halbzyklus A (Tag 1-3)

### Info-Einheit A (vor Tag 1)
```yaml
info_einheit_id: "info_a_cycle_01"
titel: "Einführung: ls, cd, pwd"
dauer: "5-10min"
typ: "reading" # reading, video, interactive
datei: "docs/exercises/cli_basics_01/info_a.md"
```

#### Inhalt der Info-Einheit
- **Befehle-Übersicht**: ls, cd, pwd
- **Wichtigste Flags**:
  - `ls -l`, `ls -a`, `ls -lah`
  - `cd -`, `cd ..`, `cd ~`
- **Praktische Beispiele**: 3-5 reale Szenarien
- **Häufige Fehler**: Was vermieden werden sollte
- **Cheat-Sheet**: Schnellreferenz zum Nachschlagen

---

### Tag 1: Programm A1

```yaml
programm_id: "A1_cycle_01"
tag: 1
halbzyklus: "A"
exercises: 3
gesamtdauer: "15min"
```

#### Exercise 1: "Navigation Basics"
```yaml
exercise_id: "A1_ex1_cycle_01"
titel: "Verzeichnisse erkunden"
dauer: "5min"
schwierigkeit: 1  # 1-10 Skala
punkte_max: 100
```

**Aufgabenstellung**:
```markdown
Navigiere zum Verzeichnis `/usr/local/bin` und liste alle Dateien auf.
Zeige dabei versteckte Dateien und Details an.

Erwarteter Befehl: cd /usr/local/bin && ls -la
```

**Bewertungskriterien**:
```yaml
punkte:
  vollständig_korrekt: 100
  korrekter_befehl_falsche_flags: 60
  korrekte_flags_falscher_pfad: 40
  hint_benutzt_1: -10  # pro Hint Abzug
  hint_benutzt_2: -20
  hint_benutzt_3: -30
  zeit_bonus:  # Bonus für schnelle Lösung
    unter_30s: +20
    unter_60s: +10
```

**Hints** (schrittweise):
```yaml
hints:
  - level: 1
    text: "Der Befehl zum Verzeichniswechsel beginnt mit 'c'"
    kosten: 10
  - level: 2
    text: "Nutze 'cd' gefolgt vom absoluten Pfad"
    kosten: 20
  - level: 3
    text: "Lösung: cd /usr/local/bin"
    kosten: 30
```

**Lernmaterial**:
```yaml
referenzen:
  - titel: "cd Command Guide"
    typ: "documentation"
    pfad: "docs/references/commands/cd.md"
  - titel: "File Listing mit ls"
    typ: "tutorial"
    pfad: "docs/references/commands/ls.md"
  - titel: "Linux Directory Structure"
    typ: "reference"
    url: "https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/"
```

**Validierung**:
```lua
validation = {
  type = "command_output",
  check_command = "pwd",
  expected_output = "/usr/local/bin",
  check_flags = {"ls", "-l", "-a"},
  alternative_flags = {"-la", "-al", "-lah"}
}
```

---

#### Exercise 2: "Flag Kombination"
```yaml
exercise_id: "A1_ex2_cycle_01"
titel: "Erweiterte Listings"
dauer: "5min"
schwierigkeit: 2
punkte_max: 100
```

**Aufgabenstellung**:
```markdown
Liste alle Dateien im aktuellen Verzeichnis auf:
- Zeige versteckte Dateien
- Zeige Details (Permissions, Größe, Datum)
- Sortiere nach Änderungsdatum (neueste zuerst)
- Zeige Größen in lesbarem Format (KB, MB)

Kombiniere die entsprechenden Flags optimal.
```

**Musterlösung**:
```bash
ls -lath
# oder
ls -l -a -t -h
```

---

#### Exercise 3: "Verzeichnis-Navigation"
```yaml
exercise_id: "A1_ex3_cycle_01"
titel: "Relativer vs. Absoluter Pfad"
dauer: "5min"
schwierigkeit: 3
punkte_max: 150  # schwierigere Aufgabe
```

---

### Tag 2: Programm A2
[Struktur analog zu A1]

### Tag 3: Programm A3
[Struktur analog zu A1]

---

## Halbzyklus B (Tag 4-6)

### Info-Einheit B (vor Tag 4)
```yaml
info_einheit_id: "info_b_cycle_01"
titel: "Dateioperationen: cp, mv, rm"
dauer: "5-10min"
datei: "docs/exercises/cli_basics_01/info_b.md"
```

### Tag 4: Programm B1
[Analog zu A1, aber mit cp/mv/rm]

### Tag 5: Programm B2
[Struktur analog]

### Tag 6: Programm B3
[Struktur analog]

---

## Wiederholungen

### Zyklus 2 (Tag 7-12)
```yaml
wiederholung: 2
anpassungen:
  schwierigkeitsgrad: "+1"
  neue_flags: ["--recursive", "--force", "--interactive"]
  kombin
