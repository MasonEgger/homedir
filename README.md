# homedir

Personal dotfiles and home directory configuration for consistent development environments across machines.

## Overview

This repository contains my personal shell configurations, editor settings, and custom utility scripts that I use to quickly set up a productive development environment on new machines. It includes configurations for `zsh` with [Oh My Zsh](https://ohmyz.sh/), Vim settings, and various helpful aliases and tools.

## Setup

### Ansible-based Setup

**Sync dev environment** (current user, any machine):
```bash
$ cd
$ git clone https://github.com/MasonEgger/homedir.git
$ cd homedir
$ ansible-playbook ansible/setup.yml    # Install everything for current user
```

**Fresh mmegger user install** (remote Debian/Ubuntu server):
```bash
ansible-playbook ansible/setup.yml --tags mmegger    # Full mmegger user setup
```

The `mmegger` tag is self-contained: creates the user, hardens SSH, and then installs all packages, dotfiles, and tools for the mmegger user.

**Modular Installation Options (sync scenario):**
```bash
# Install specific components for the current user
ansible-playbook ansible/setup.yml --tags packages     # Only install packages
ansible-playbook ansible/setup.yml --tags dotfiles     # Only install core dotfiles
ansible-playbook ansible/setup.yml --tags claude       # Only install .claude directory
ansible-playbook ansible/setup.yml --tags homedir      # Only install .homedir scripts

# Combine multiple components
ansible-playbook ansible/setup.yml --tags packages,dotfiles
ansible-playbook ansible/setup.yml --tags claude,homedir
```

**Check Mode and Preview Options:**
```bash
# See what would change without making changes
ansible-playbook ansible/setup.yml --check
ansible-playbook ansible/setup.yml --tags dotfiles --check

# Show detailed before/after diffs of file changes
ansible-playbook ansible/setup.yml --check --diff
ansible-playbook ansible/setup.yml --tags dotfiles --check --diff
```

**Additional Options:**
- `--check` - Preview changes without making them
- `--diff` - Show detailed before/after diffs

**Features:**
- **Modular installation**: Install only the components you need (packages, dotfiles, claude, homedir)
- **Cross-platform package management**: Automatically installs development tools via Homebrew (macOS) or apt (Ubuntu/Debian)
- **Check mode support**: Preview changes before making them with `--check` and `--diff`
- **Idempotent**: Safe to run multiple times, only makes necessary changes

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
- **Local configuration**: `~/.zshrc.local` for machine-specific settings (auto-created, git-ignored)
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
| `claude-plugins` | Install or update Claude Code plugins from official and personal marketplaces | None | `claude-plugins` |

### Claude Settings (`.claude/`)

| File | Description |
|------|-------------|
| `CLAUDE.md` | Development guidelines for Claude AI assistant (separate from root CLAUDE.md) |
| `settings.json` | Global Claude Code configuration |
| `skills/python/` | Python development standards skill (toolchain, TDD, CLI scripts, documentation) |

Claude Code plugins (BPE workflow, writing toolkit, productivity commands) live in a separate repository: [MasonEgger/claude-code-plugin](https://github.com/MasonEgger/claude-code-plugin). The `claude-plugins` script in `.homedir/` handles installing them from that marketplace.

## File Structure

```
.
├── .claude/                      # Claude AI assistant configuration
│   ├── CLAUDE.md                 # Claude-specific documentation
│   ├── settings.json             # Global Claude settings
│   └── skills/                   # Claude Code skills
│       └── python/               # Python development standards
│           ├── SKILL.md
│           └── references/       # Toolchain, TDD, CLI, docs guides
├── .homedir/                     # Custom utility scripts
│   ├── claude-plugins            # Claude Code plugin installer
│   ├── lmsify                    # Markdown to HTML converter
│   ├── my-tools                  # Tool help display
│   └── wordcount                 # Word count utility
├── ansible/                      # Ansible automation setup
│   ├── setup.yml                 # Main Ansible playbook (orchestration only)
│   ├── group_vars/               # Variable definitions
│   │   └── all.yml               # Package lists and configuration
│   ├── tasks/                    # Modular task definitions
│   │   ├── packages.yml          # System packages (apt/brew)
│   │   ├── user-tools.yml        # Per-user tools (Oh My Zsh, Claude CLI, uv)
│   │   ├── dotfiles.yml          # Core dotfiles installation
│   │   ├── claude.yml            # .claude directory + plugin installation
│   │   ├── homedir.yml           # .homedir scripts installation
│   │   ├── vale.yml              # Vale prose linter
│   │   ├── git-hooks.yml         # Global git hooks
│   │   ├── tailscale.yml         # Tailscale VPN
│   │   └── mmegger.yml           # Full user provisioning
│   ├── ansible.cfg               # Ansible configuration
│   ├── hosts                     # Localhost inventory
│   └── requirements.yml          # External role dependencies
├── .tmux.conf                    # Tmux terminal multiplexer configuration
├── .vimrc                        # Vim configuration
├── .zshrc                        # Zsh configuration with aliases
├── .zshrc.local.example          # Template for machine-specific zsh configuration
├── CLAUDE.md                     # Instructions for Claude AI assistant
└── README.md                     # This file
```

## Machine-Specific Configuration

### Using `.zshrc.local`

The `.zshrc.local` file allows you to maintain machine-specific settings without modifying the tracked `.zshrc` file. This is perfect for:

- **API keys and secrets** (OpenAI, GitHub tokens, AWS credentials)
- **Machine-specific PATH additions** (local binaries, custom tools)
- **Local aliases** (project shortcuts specific to this machine)
- **Environment variables** (DEBUG flags, local development settings)
- **Override repository defaults** (custom themes, plugins)

**Setup**:
- Automatically created during Ansible setup if it doesn't exist
- Ignored by git (safe for secrets and machine-specific settings)
- Never overwritten when re-running `ansible-playbook`
- Sourced at the end of `.zshrc` (settings here override repository defaults)

**Usage**:
```bash
# Edit your local configuration
vim ~/.zshrc.local

# Example content:
export OPENAI_API_KEY="sk-..."
alias myproject="cd ~/Projects/my-special-project"
export PATH="$HOME/bin:$PATH"
```

See `.zshrc.local.example` in the repository for more examples.

## Notes

- **Package Dependencies**: The Ansible setup automatically installs required packages including `lolcat`, development tools, and `uv`
- The `lmsify` command requires `lessonmd` tool to be installed (not included in automated setup)
- The `wordcount` script uses `uv` for Python script execution and supports multiple output formats (text, JSON, CSV)
- All custom scripts in `.homedir/` are executable and added to PATH
- **Ansible Requirement**: Ensure Ansible is installed (`pip install ansible` or `brew install ansible`)
- **Safe re-runs**: Running `ansible-playbook ansible/setup.yml` multiple times is safe and idempotent

## Contributing

This is a personal configuration repository, but feel free to fork and adapt for your own use. When making changes:
- Test new aliases and scripts locally before committing
- Ensure shell scripts are executable (`chmod +x`)
- Avoid machine-specific configurations

## Claude.md

The CLAUDE.md file provides guidance to Claude Code (claude.ai/code) when working with this repository. Claude.md crafted by myself, and shamelessly taken from [harperreed](https://github.com/harperreed/dotfiles/tree/master/.claude)