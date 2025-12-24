# Changelog

All notable changes to learn-cli.nvim will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features

- [ ] Exercise view with integrated terminal
- [ ] Timer with visual countdown
- [ ] Hint reveal system with progressive disclosure
- [ ] Exercise file creation in temp directory
- [ ] Verification system for exercise completion
- [ ] Cycle progress tracking
- [ ] Advanced filtering and search in dashboard
- [ ] Exercise tagging and filtering by tag
- [ ] Favorite exercises system
- [ ] Exercise review scheduler (spaced repetition)
- [ ] Export/import exercise packs
- [ ] Community exercise sharing
- [ ] Interactive tutorials for beginners
- [ ] Achievement/badge system
- [ ] Leaderboard (optional, privacy-first)
- [ ] Dark/light theme support
- [ ] Customizable color schemes
- [ ] Multi-language support for UI
- [ ] Exercise creation wizard
- [ ] Auto-generated exercises from man pages
- [ ] Integration with tldr pages
- [ ] Video/GIF demonstration support
- [ ] Voice hints (TTS integration)
- [ ] Gamification elements
- [ ] Practice streaks tracking
- [ ] Difficulty auto-adjustment based on performance
- [ ] Custom scoring formulas
- [ ] Exercise dependencies graph visualization
- [ ] Progress charts and analytics
- [ ] Comparison with other learners (opt-in)
- [ ] AI-powered hint generation
- [ ] Real-time collaboration (pair learning)

## [0.1.0] - 2024-12-24

### Added

- Initial plugin architecture
- Core module structure
- Configuration system with defaults
- State management with persistence
- Dashboard UI with statistics
- Scoring engine with adaptive difficulty
- Type definitions for LSP support
- Exercise definition system
- Cycle management system
- Built-in grep exercises (4 exercises)
- Data persistence (JSON-based)
- Ex commands (:LearnCli, :LearnCliStats, etc.)
- Configurable keymaps
- Progress tracking and history
- Time tracking with adaptive targets
- Hint system with score penalties
- References and documentation links
- Exercise tagging system
- Prerequisites system for exercises
- Auto-save functionality
- Backup and restore capabilities
- Export/import progress data
- Health check integration
- Comprehensive README
- Developer documentation
- MIT License

### Technical

- Follows Neovim Lua plugin architecture best practices
- Implements error handling with pcall throughout
- Uses type guards for all API calls
- Buffer/window validation before operations
- No global state - centralized state management
- Performance optimizations (table pre-allocation, string concat)
- Async operations for background tasks
- Weak tables for caching
- Modular design with single responsibility
- Extensive annotations for LSP support
- Configurable with sensible defaults

## [0.0.1] - 2024-12-24

### Added

- Project initialization
- Directory structure
- Basic file templates
- License file
- Empty placeholder files

---

## Version Guidelines

### Version Number Format

`MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Change Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes
- **Technical**: Internal improvements (architecture, performance, refactoring)

### Commit Message Convention

Use conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, missing semicolons, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Maintenance (dependencies, configs, etc.)

**Example:**
```
feat(scoring): add accuracy-based bonus to score calculation

Adds a new accuracy metric to the scoring system that rewards
users who complete exercises with fewer mistakes.

Closes #123
```
