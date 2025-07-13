# homedir

Personal dotfiles and home directory configuration for consistent development environments across machines.

## Overview

This repository contains my personal shell configurations, editor settings, and custom utility scripts that I use to quickly set up a productive development environment on new machines. It includes configurations for `zsh` with [Oh My Zsh](https://ohmyz.sh/), Vim settings, and various helpful aliases and tools.

## Setup

### Recommended (Automated Setup with Backups)

```bash
$ cd
$ git clone https://github.com/MasonEgger/homedir.git
$ cd homedir
$ ./setup.sh              # Default: Prompts for confirmation before installing
```

**Setup Script Options:**
- `./setup.sh -i` - Interactive mode: Confirm each file individually
- `./setup.sh -n` - Dry-run mode: Show what would be done without making changes
- `./setup.sh -x` - Exclude .claude directory from installation
- `./setup.sh -v` - Verbose output
- `./setup.sh -b DIR` - Custom backup directory

## What's Included

### Shell Configuration (`.zshrc`)

| Alias/Command | Description | Usage |
|---------------|-------------|-------|
| `cdr` | Navigate to git repository root | `cdr` |
| `..` | Go up one directory | `..` |
| `...` | Go up two directories | `...` |
| `....` | Go up three directories | `....` |
| `.....` | Go up four directories | `.....` |
| `......` | Go up five directories | `......` |
| `venv-on` | Activate Python virtual environment at git root | `venv-on` |
| `python` | Alias for python3 | `python <script.py>` |
| `django` | Shortcut for python manage.py | `django <command>` |
| `uuid` | Generate lowercase UUID with colorful output (using lolcat) | `uuid` |

**Additional Configuration:**
- **Shell**: Zsh with Oh My Zsh (geoffgarside theme)
- **Plugins**: git
- **Path additions**: `~/.homedir`
- **Other**: thefuck alias integration, GPG TTY export

### Editor Configuration (`.vimrc`)

| Configuration | Vim Command | Description |
|---------------|-------------|-------------|
| Command height | `set cmdheight=2` | Enhanced command line display area |
| Backspace behavior | `set backspace=2` | Enable proper backspace functionality |
| Search highlighting | `set hlsearch` | Highlight search results |
| Line numbers | `set number` | Display line numbers |
| Ruler display | `set ruler` | Show cursor position in status line |
| Column marker | `set cc=80` | 80-character column marker |
| Tab expansion | `set expandtab` | Convert tabs to spaces |
| Tab size | `set ts=4` | 4-space tab width |
| Color scheme | `colorscheme slate` | Slate color theme |
| Syntax highlighting | `syntax on` | Enable syntax highlighting |

### Terminal Multiplexer Configuration (`.tmux.conf`)
- **Mouse support**: Enabled for scrolling and pane selection
- **Function key bindings**:
  - `F2` - Create new window
  - `F3` - Previous window
  - `F4` - Next window
  - `Ctrl+F2` - Horizontal split
  - `Shift+F2` - Vertical split
- **Pane navigation**: `Shift+Arrow` keys to move between panes
- **Visual**: Magenta status bar with black text, colored pane borders
- **Settings**: 10,000 line scrollback buffer, 256-color support, windows numbered from 1

### Custom Tools (`.homedir/`)

| Command | Description | Arguments | Usage Example |
|---------|-------------|-----------|---------------|
| `lmsify` | Convert GitHub Flavored Markdown to HTML for LMS publication (copies to clipboard using `pbcopy`) | `<file.md>` - Markdown file to convert | `lmsify lesson.md` |
| `wordcount` | Count words in files/directories, excluding Markdown code blocks | `<path> [options]` - File or directory to process with various options | `wordcount README.md` or `wordcount . -r -f json` |
| `my-tools` | Display help for available custom tools | None | `my-tools` |

### Claude Settings (`.claude/`)

| File | Description | Contents |
|------|-------------|----------|
| `settings.json` | Global Claude configuration | Basic settings for Claude behavior |
| `settings.local.json` | Local Claude permissions configuration | Allows specific bash commands: `find`, `ls`, `cat` |
| `CLAUDE.md` | Claude-specific documentation | Detailed instructions for Claude AI assistant (separate from root CLAUDE.md) |
| `commands/` | Directory containing Claude command definitions | Custom commands and workflows |
| `docs/` | Additional Claude documentation | Extended documentation and examples |

#### Custom Claude Commands (`.claude/commands/`)

| Command | Description | Arguments |
|---------|-------------|-----------|
| `brainstorm` | Interactive specification development through iterative questioning | None |
| `do-gh-issue` | Retrieve GitHub issue, validate, plan, and implement solution with tests | GitHub issue number |
| `do-prompt-plan` | Execute incomplete prompts from @prompt_plan.md with testing and commits | None (reads from @prompt_plan.md) |
| `do-todo` | Work through unchecked items in @todo.md with comprehensive implementation | None (reads from @todo.md) |
| `find-missing-tests` | Analyze code for missing test cases and create test coverage improvement plan | None (analyzes current codebase) |
| `lyra` | AI prompt optimization specialist using 4-D methodology (Deconstruct, Diagnose, Develop, Deliver) | Target AI platform, prompt style (DETAIL/BASIC), rough prompt |
| `plan` | Create detailed project blueprint with iterative, test-driven implementation steps | Project specification file path |
| `session-summary` | Generate comprehensive session summary with costs, insights, and improvements | None |
| `setup` | Configure Python project with uv, workflow guidelines, testing, and linting requirements | None (configures current project) |

#### Claude Documentation (`.claude/docs/`)

| Document | Description | Contents |
|----------|-------------|----------|
| `python.md` | Python development guidelines and standards | Modern Pythonic style, type hints, tools (ruff, mypy, pytest, uv), strict mode requirements |

## File Structure

```
.
├── .claude/                      # Claude AI assistant configuration
│   ├── CLAUDE.md                 # Claude-specific documentation  
│   ├── commands/                 # Custom Claude commands
│   │   ├── brainstorm.md         # Interactive specification development
│   │   ├── do-gh-issue.md        # GitHub issue resolution workflow
│   │   ├── do-prompt-plan.md     # Execute prompt plans with testing
│   │   ├── do-todo.md            # Todo list execution workflow
│   │   ├── find-missing-tests.md # Test coverage analysis
│   │   ├── lyra.md               # AI prompt optimization specialist
│   │   ├── plan.md               # Project planning and blueprints
│   │   ├── session-summary.md    # Session documentation generator
│   │   └── setup.md              # Python project configuration
│   ├── docs/                     # Additional Claude documentation
│   │   └── python.md             # Python development guidelines
│   ├── settings.json             # Global Claude settings
│   └── settings.local.json       # Local permissions config
├── .homedir/                     # Custom utility scripts
│   ├── lmsify                    # Markdown to HTML converter
│   ├── my-tools                  # Tool help display
│   └── wordcount                 # Word count utility
├── .tmux.conf                    # Tmux terminal multiplexer configuration
├── .vimrc                        # Vim configuration
├── .zshrc                        # Zsh configuration with aliases
├── CLAUDE.md                     # Instructions for Claude AI assistant
├── README.md                     # This file
└── setup.sh                      # Automated setup script
```

## Notes

- The `uuid` alias requires `lolcat` to be installed for colorful output
- The `lmsify` command requires `lessonmd` tool to be installed
- The `wordcount` script uses `uv` for Python script execution and supports multiple output formats (text, JSON, CSV)
- All custom scripts in `.homedir/` are executable and added to PATH

## Contributing

This is a personal configuration repository, but feel free to fork and adapt for your own use. When making changes:
- Test new aliases and scripts locally before committing
- Ensure shell scripts are executable (`chmod +x`)
- Avoid machine-specific configurations

## Claude.md

The CLAUDE.md file provides guidance to Claude Code (claude.ai/code) when working with this repository. Claude.md crafted by myself, and shamelessly taken from [harperreed](https://github.com/harperreed/dotfiles/tree/master/.claude)