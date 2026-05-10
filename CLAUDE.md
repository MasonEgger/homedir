# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles/homedir configuration repository used to quickly set up a consistent development environment across different machines. The repository contains shell configurations, editor settings, custom utility scripts, and Ansible automation to deploy them.

## Setup Method

### Ansible-based Setup

There are two main scenarios:

**1. Sync dev environment** (current user, any machine):
```bash
cd ~/homedir
ansible-playbook ansible/setup.yml                     # Install everything for current user
```

**2. Fresh mmegger user install** (remote Debian/Ubuntu server):
```bash
ansible-playbook ansible/setup.yml --tags mmegger       # Full mmegger user setup
```

The `mmegger` tag is self-contained: installs all system packages and tools, creates the user, sets up SSH with sshid.io keys, hardens SSH, then installs all per-user configs (Oh My Zsh, dotfiles, Claude CLI, uv, .claude directory, .homedir scripts, vale config, git hooks).

**Modular Installation Options (sync scenario):**
```bash
ansible-playbook ansible/setup.yml --tags packages      # System packages only (apt/brew + kubectl, just, lychee)
ansible-playbook ansible/setup.yml --tags user-tools    # Per-user curl installs (Oh My Zsh, Claude CLI, uv)
ansible-playbook ansible/setup.yml --tags dotfiles      # Core dotfiles (.zshrc, .vimrc, .tmux.conf, .gitconfig)
ansible-playbook ansible/setup.yml --tags claude        # .claude directory
ansible-playbook ansible/setup.yml --tags homedir       # .homedir scripts
ansible-playbook ansible/setup.yml --tags vale          # Vale prose linter
ansible-playbook ansible/setup.yml --tags git-hooks     # Global git hooks
ansible-playbook ansible/setup.yml --tags tailscale     # Tailscale VPN
ansible-playbook ansible/setup.yml --tags obsidian      # Obsidian (cask on macOS, headless AppImage on Ubuntu)

# Combine tags
ansible-playbook ansible/setup.yml --tags packages,dotfiles
```

**Additional Options:**
- `--check` - Preview changes without making them
- `--diff` - Show detailed before/after diffs

## Ansible Architecture

### Task Organization

`setup.yml` is orchestration-only — all logic lives in `ansible/tasks/`:

| Tag | Task File | Scope | Description |
|-----|-----------|-------|-------------|
| `packages` | `packages.yml` | System | apt/brew packages, kubectl, just, lychee (all install to system paths) |
| `user-tools` | `user-tools.yml` | Per-user | Oh My Zsh, Claude Code CLI, uv (all curl-based, install to `$HOME`) |
| `dotfiles` | `dotfiles.yml` | Per-user | .zshrc, .vimrc, .tmux.conf, .gitconfig (with GPG/SSH key detection) |
| `claude` | `claude.yml` | Per-user | .claude directory (settings, skills) + plugin installation from marketplace |
| `homedir` | `homedir.yml` | Per-user | .homedir scripts, sets executable permissions |
| `vale` | `vale.yml` | Mixed | Vale binary (system) + .vale.ini config (per-user) |
| `git-hooks` | `git-hooks.yml` | Per-user | Global git hooks directory |
| `tailscale` | `tailscale.yml` | System | Tailscale VPN (brew on macOS, official script on Linux) |
| `obsidian` | `obsidian.yml` | Per-user | Obsidian — Homebrew cask on macOS; on Ubuntu, headless AppImage + bundled `obsidian-cli` + nvm/Node + `obsidian-headless` (`ob`) + two systemd `--user` services |
| `mmegger` | `mmegger.yml` | Both | Full user provisioning — hidden tag (`[never, mmegger]`) |

### Target User Pattern

Task files support two modes via the `target_user` / `target_home` variables:

- **Undefined** (sync scenario): runs as current user, no privilege escalation
- **Defined** (mmegger scenario): `mmegger.yml` re-includes task files with `vars: { target_home: /home/mmegger, target_user: mmegger }`

Per-user shell tasks (user-tools.yml) use `su - {{ target_user }}` instead of Ansible's `become_user` to avoid temp file permission errors on local connections. Each task has two variants: `(target user)` and `(current user)`.

### mmegger Provisioning Order

The ordering in `mmegger.yml` matters:
1. **System packages** (packages, vale binary, tailscale) — no user needed
2. **User creation** (ensure zsh, create user, force password change)
3. **SSH setup** (authorized_keys, sshid.io keys, key generation, SSH hardening)
4. **Per-user configs** (user-tools, dotfiles, claude, homedir, git-hooks)

Variables in `ansible/group_vars/all.yml` define package lists and defaults.

### Obsidian Task — Two-Pass Flow

Unlike other tasks, `obsidian.yml` on Ubuntu has interactive sub-steps (Obsidian Sync login + e2e password) that can't be automated. The task is designed to be run twice:

1. **Pass 1** (`--tags obsidian`): installs AppImage, extracts `obsidian-cli` to `~/.local/bin/obsidian`, installs nvm + Node LTS + `obsidian-headless`, writes systemd `--user` units, starts `obsidian.service`, runs `loginctl enable-linger`. No vault yet.
2. **User runs interactively**: `ob login`, `ob sync-setup --vault NAME --path ~/NAME`, then `ob sync-config --path ~/NAME --mode pull-only --configs ...` (pull-only is mandatory — bidirectional with empty defaults will overwrite cloud configs).
3. **Pass 2** (`--tags obsidian -e obsidian_vault_name=NAME`): registers the vault in `obsidian.json`, restarts Obsidian, runs `app.plugins.setEnable(true)` (loads community plugins — headless mode skips the trust prompt that would normally do this), enables `ob-sync.service`.

The systemd units run with Electron's built-in `--ozone-platform=headless` flag — no Xvfb needed. Templates live in `ansible/templates/obsidian-headless.service.j2`, `ob-sync.service.j2`, `ob-sync-wrapper.sh.j2`, `obsidian.json.j2`.

**Linux task assumes target user.** `obsidian.yml` uses `ansible_user_dir` and `systemctl --user`, so it runs only as the target user. The `mmegger` flow can include it but doesn't currently pass `target_home` — if you ever need root-bootstrapped headless Obsidian, both `mmegger.yml`'s include and `obsidian.yml`'s path references need adjusting.

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
- `wordcount <file>` - Count words in file, excluding Markdown code blocks. Supports `-r` (recursive), `-f {text|json|csv}` (format), `-o FILE` (output), `--no-exclude-code-blocks`
- `my-tools` - Display help for available custom tools

## Development Environment

- **Shell**: Zsh with Oh My Zsh (geoffgarside theme), `thefuck` integration, GPG TTY export
- **Path**: `~/.homedir` added to PATH; JAVA_HOME detected dynamically (Homebrew or `/usr/lib/jvm/default-java`)
- **Local overrides**: `~/.zshrc.local` sourced at end of `.zshrc` (git-ignored, auto-created by Ansible)
- **Editor**: Vim with line numbers, search highlighting, 80-char column marker, 4-space tabs
- **Tmux**: Mouse support, function key bindings (F2-F4), magenta status bar, 10k scrollback

## Commands for Development

### Testing and Validation
```bash
# Test utility scripts after modification
.homedir/my-tools                    # Should display help text
.homedir/wordcount README.md         # Should count words (returns just number for single files)
.homedir/wordcount . -r              # Recursively count words in directory
.homedir/lmsify test.md              # Should convert markdown (requires lessonmd)

# Verify aliases work after .zshrc changes
source ~/.zshrc

# Validate Ansible playbook syntax
ansible-playbook ansible/setup.yml --check --diff
```

### Repository Maintenance
```bash
cd ~/homedir
git pull origin main
ansible-playbook ansible/setup.yml  # Re-run to update files
```

## Common Tasks

### Adding a New Alias
1. Edit `.zshrc`, add the alias in the appropriate section
2. Test by sourcing: `source ~/.zshrc`

### Adding a New Utility Script
**Always write new homedir scripts in Python following the guidelines in the Python skill (`.claude/skills/python/`):**
1. Create Python script in `.homedir/` with PEP 723 inline metadata:
   - Use `#!/usr/bin/env -S uv run --script` shebang
   - Include `# /// script` metadata block with dependencies
   - Follow modern Pythonic style with type hints and docstrings
   - Use `ruff` formatting and `mypy --strict` type checking
2. Make it executable: `chmod +x .homedir/script-name`
3. The script will be automatically available in PATH after Ansible setup
4. Update `my-tools` script to include the new tool in help output
5. Update README.md to document the new tool

### Adding a New Ansible Task
1. Create a new task file in `ansible/tasks/`
2. Add an `include_tasks` entry in `setup.yml` with a tag
3. If it should run during mmegger provisioning, add an include in `mmegger.yml` at the appropriate point in the ordering (system vs. per-user)
4. Update the installation summary in `setup.yml`
