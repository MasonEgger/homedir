# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles/homedir configuration repository used to quickly set up a consistent development environment across different machines. The repository contains shell configurations, editor settings, and custom utility scripts.

## Setup Methods

### Manual Setup
```bash
cd
git clone https://github.com/MasonEgger/homedir.git
mv homedir/.[Xa-z]* homedir/* .
rmdir homedir
```

### Automated Setup
```bash
cd
git clone https://github.com/MasonEgger/homedir.git
cd homedir
./setup.sh              # Default: Prompts for confirmation before installing
./setup.sh -i           # Interactive mode: Confirm each file individually
./setup.sh -n           # Dry-run mode: Show what would be done without making changes
./setup.sh -x           # Exclude .claude directory from installation
./setup.sh -v           # Verbose output
./setup.sh -b DIR       # Custom backup directory (default: ~/.homedir-backup-TIMESTAMP)
```

The setup script features:
- Creates timestamped backups of existing dotfiles in `~/.homedir-backup-YYYYMMDD_HHMMSS`
- Excludes documentation files (README.md, CLAUDE.md, setup.sh)
- Automatically makes all scripts in `.homedir/` executable
- Preserves the repository for future updates
- Supports combining options (e.g., `./setup.sh -n -v` for verbose dry-run)
- Shows installation summary with counts of installed/skipped files

## Key Commands and Aliases

### Navigation
- `cdr` - Navigate to the root of the current git repository
- `..`, `...`, `....`, `.....`, `......` - Quick navigation up directory levels (1-5 levels)

### Python Development
- `venv-on` - Activate Python virtual environment at git repository root (`.venv/bin/activate`)
- `python` - Aliased to `python3`
- `django` - Shortcut for `python manage.py`

### Utilities
- `uuid` - Generate a lowercase UUID with colorful output (requires `lolcat`)
- `lmsify <file.md>` - Convert GitHub Flavored Markdown to HTML for LMS publication (requires `lessonmd` tool)
- `wordcount <file>` - Count words in file, excluding Markdown code blocks. Supports various options:
  - `-r, --recursive` - Process directories recursively  
  - `-f, --format {text|json|csv}` - Output format
  - `-o, --output FILE` - Save output to file
  - `--no-exclude-code-blocks` - Count words in code blocks
- `my-tools` - Display help for available custom tools

## Development Environment

### Shell Configuration
- **Shell**: Zsh with Oh My Zsh (geoffgarside theme)
- **Plugins**: git
- **Path additions**: `~/.homedir`, Java OpenJDK 20.0.2 (`~/OpenJDK/jdk-20.0.2.jdk/Contents/Home`)
- **Integrations**: `thefuck` command correction tool, GPG TTY export

### Editor Configuration
- **Vim**: Line numbers, search highlighting, 80-char column marker, 4-space tabs, slate color scheme

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

## File Structure

```
.
├── .homedir/                    # Custom utility scripts
│   ├── lmsify                   # Markdown to HTML converter (bash script)
│   ├── my-tools                 # Tool help display (bash script)
│   └── wordcount                # Word count utility (Python script using uv)
├── .tmux.conf                   # Tmux terminal multiplexer configuration
├── .vimrc                       # Vim configuration
├── .zshrc                       # Zsh configuration with aliases
├── setup.sh                     # Automated setup script
├── CLAUDE.md                    # This file
└── README.md                    # Repository documentation
```

## Working with This Repository

When making changes to this repository:
1. Test any new aliases or scripts locally before committing
2. Ensure shell scripts are executable (`chmod +x`)
3. Update README.md for user-facing changes
4. Be mindful that this repository is used across multiple machines - avoid machine-specific configurations
5. Never commit sensitive information (API keys, tokens)

## Commands for Development

### Testing and Validation
To test changes to utility scripts and configurations:
```bash
# Test utility scripts after modification
.homedir/my-tools                    # Should display help text
.homedir/wordcount README.md         # Should count words (returns just number for single files)
.homedir/wordcount . -r              # Recursively count words in directory
.homedir/lmsify test.md              # Should convert markdown (requires lessonmd)

# Verify aliases work after .zshrc changes
source ~/.zshrc
uuid                                 # Should generate colored UUID (requires lolcat)
cdr                                  # Should navigate to git repository root
venv-on                              # Should activate .venv if it exists

# Test configuration files
vim                                  # Should show line numbers, 80-char column marker
tmux                                 # Should use magenta status bar with function key bindings
```

### Repository Maintenance
```bash
# Keep repository in sync after setup
cd ~/homedir
git pull origin main
./setup.sh  # Re-run to update files
```

## Common Tasks

### Adding a New Alias
1. Edit `.zshrc`
2. Add the alias in the appropriate section (around lines 18-27)
3. Test by sourcing: `source ~/.zshrc`

### Adding a New Utility Script
1. Create the script in `.homedir/`
2. Make it executable: `chmod +x .homedir/script-name`
3. The script will be automatically available in PATH after setup
4. Update `my-tools` script to include the new tool in help output
5. Update README.md to document the new tool

### Modifying Vim Configuration
1. Edit `.vimrc`
2. Test changes by reopening vim or running `:source ~/.vimrc`

## Dependencies

- **Required**: Zsh, Oh My Zsh
- **Optional**: 
  - `lolcat` - For colorful UUID output
  - `lessonmd` - For `lmsify` command
  - `uv` - For `wordcount` Python script execution
  - `thefuck` - For command correction
  - Java OpenJDK 20.0.2 - If using Java development

## Architecture Notes

### Setup Script Behavior
The `setup.sh` script preserves the cloned repository in `~/homedir/` after installation. This allows for:
- Easy updates via `git pull` and re-running setup
- Version control tracking of dotfile changes
- Rollback capabilities if needed

### Script Execution Model
- Shell scripts in `.homedir/` are made executable automatically during setup
- Python scripts use `uv` for execution (e.g., `wordcount` uses `#!/usr/bin/env -S uv run --script`)
- All scripts assume they're run from any directory (use absolute paths internally)
- The `wordcount` script supports multiple output formats (text, JSON, CSV) and advanced options for markdown processing

## Claude-Specific Settings

The `.homedir/.claude/settings.local.json` file contains permissions for specific bash commands that Claude can execute:
- `find`, `ls`, `chmod`, `my-tools`

This ensures Claude can help with file discovery and permission management while maintaining security.