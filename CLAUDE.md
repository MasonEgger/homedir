# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles/homedir configuration repository used to quickly set up a consistent development environment across different machines. The repository contains shell configurations, editor settings, and custom utility scripts.

## Setup Instructions

To set up this homedir on a new machine:
```bash
cd
git clone https://github.com/MasonEgger/homedir.git
mv homedir/.[Xa-z]* homedir/* .
rmdir homedir
```

## Key Commands and Aliases

### Navigation
- `cdr` - Navigate to the root of the current git repository
- `..`, `...`, `....` - Quick navigation up directory levels

### Python Development
- `venv-on` - Activate Python virtual environment at git repository root (`venv/bin/activate`)
- `python` - Aliased to `python3`
- `django` - Shortcut for `python manage.py`

### Utilities
- `lmsify <file.md>` - Convert GitHub Flavored Markdown to HTML for LMS publication (requires `lessonmd` tool)
- `getid` - Generate a lowercase UUID with colorful output

## Development Environment

### Shell Configuration
- **Shell**: Zsh with Oh My Zsh (geoffgarside theme)
- **Plugins**: git
- **Path additions**: `~/.homedir`, Java OpenJDK 20.0.2, pipx binaries

### Editor Configuration
- **Vim**: Line numbers, search highlighting, 80-char column marker, 4-space tabs, slate color scheme

## File Structure

```
.
├── .homedir/           # Custom utility scripts
│   └── lmsify         # Markdown to HTML converter for LMS
├── .vimrc             # Vim configuration
├── .zshrc             # Zsh configuration with aliases
├── .claude/           # Claude-specific configuration (if needed)
└── README.md          # Repository setup instructions
```

## Working with This Repository

When making changes to this repository:
1. Test any new aliases or scripts locally before committing
2. Ensure shell scripts are executable (`chmod +x`)
3. Document any new utilities or significant configuration changes
4. Be mindful that this repository is used across multiple machines - avoid machine-specific configurations

## Common Tasks

### Adding a New Alias
1. Edit `.zshrc`
2. Add the alias in the appropriate section
3. Test by sourcing: `source ~/.zshrc`

### Adding a New Utility Script
1. Create the script in `.homedir/`
2. Make it executable: `chmod +x .homedir/script-name`
3. The script will be automatically available in PATH after setup

### Modifying Vim Configuration
1. Edit `.vimrc`
2. Test changes by reopening vim or running `:source ~/.vimrc`