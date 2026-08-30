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
ansible-playbook ansible/setup.yml                     # Install everything (except opt-in Obsidian) for current user
```

**2. Fresh mmegger user install** (remote Debian/Ubuntu server):
```bash
ansible-playbook ansible/setup.yml --tags mmegger       # Full mmegger user setup
```

The `mmegger` tag is self-contained: installs all system packages and tools, creates the user, sets up SSH with sshid.io keys, hardens SSH, then installs all per-user configs (Oh My Zsh, dotfiles, Claude CLI, uv, .claude directory, .homedir scripts, vale config, git hooks).

**3. Fresh install for any other user** (remote Debian/Ubuntu server):
```bash
ansible-playbook ansible/setup.yml --tags new-user -e new_user_name=alice
```

`new-user` runs `tasks/user.yml` directly: user creation, SSH bootstrap and hardening, and all per-user configs, without the system package step.
Override `new_user_shell`, `new_user_home`, `new_user_groups`, `new_user_password`, `new_user_email`, or `new_user_sshid_user` with `-e` as needed (defaults in `ansible/group_vars/all.yml`).

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
| `vale` | `vale.yml` | Mixed | Vale binary (system) + vale-styles repo clone to `~/Code/vale-styles` + `.vale.ini` config (per-user) |
| `git-hooks` | `git-hooks.yml` | Per-user | Global git hooks directory |
| `tailscale` | `tailscale.yml` | System | Tailscale VPN (brew on macOS, official script on Linux) |
| `obsidian` | `obsidian.yml` | Per-user | Obsidian — Homebrew cask on macOS; on Ubuntu, headless AppImage + bundled `obsidian-cli` + nvm/Node + `obsidian-headless` (`ob`) + two systemd `--user` services. Opt-in (`[never, obsidian]`): a bare `setup.yml` run skips it; run `--tags obsidian` explicitly |
| `new-user` | `user.yml` | Both | Parameterized user provisioning driven by `new_user_*` vars: creates user, SSH bootstrap + hardening, per-user configs. Hidden tag (`[never, new-user]`) |
| `mmegger` | `mmegger.yml` | Both | System packages, then `user.yml` with `new_user_name: mmegger`, then Tailscale. Obsidian is deliberately excluded (self-service post-login). Hidden tag (`[never, mmegger]`) |

### Target User Pattern

Task files support two modes via the `target_user` / `target_home` variables:

- **Undefined** (sync scenario): runs as current user, no privilege escalation
- **Defined** (mmegger / new-user scenario): `user.yml` re-includes task files with `vars: { target_home: "{{ new_user_home }}", target_user: "{{ new_user_name }}" }`

Both entry points reach `user.yml`'s tasks via `apply:` on the include (`mmegger.yml` and the `new-user` include in `setup.yml`), so a task added to `user.yml` runs under both tags even if you forget to tag it. The leaf `[mmegger, new-user]` tags on `user.yml`'s tasks are now redundant belt-and-suspenders, not load-bearing.

Per-user shell tasks (user-tools.yml, claude.yml) use `runuser -l {{ target_user }}` instead of Ansible's `become_user` to avoid temp file permission errors on local connections. `runuser` rather than `su -` because su's PAM account check enforces the `chage -d 0` password expiry and would fail every re-run. Each task has two variants: `(target user)` and `(current user)`.

### Provisioning Order

The account is created as early as the package dependency allows, so a failure in any
later network task (Tailscale, or a self-service Obsidian run) never leaves a box without
a usable, reachable `mmegger` account. `mmegger.yml` order:

1. **System packages** (`packages.yml`, root): must run first because `user-tools.yml` needs `git`/`curl` from apt.
2. **User account + configs** (`user.yml`): create user, SSH bootstrap + hardening, then all per-user configs.
3. **Tailscale** (`tailscale.yml`, root): a `curl | sh` network install, ordered AFTER the account so a failure cannot block user creation.

Within `user.yml` the ordering also matters:
1. **User creation** (ensure zsh, ensure docker group, create user with temp password)
2. **SSH setup** (root authorized_keys, sshid.io keys, key generation)
3. **SSH hardening** (disable password auth). Guarded: skipped with a warning unless the account has at least one `authorized_keys` entry, so a keyless run cannot lock you out.
4. **Per-user configs** (user-tools, vale, dotfiles, homedir, claude, git-hooks). homedir must precede claude: the target-user plugin install runs `~/.homedir/claude-plugins`
5. **Wrap-up** (force password change on first login, print the generated public key)

Obsidian is NOT in the `mmegger` flow. `obsidian.yml` is per-user, `systemctl --user`, and two-pass interactive, so it only installs correctly when run AS the logged-in user. After first login: `ssh mmegger@host`, then `cd ~/homedir && ansible-playbook ansible/setup.yml --tags obsidian`.

Variables in `ansible/group_vars/all.yml` define package lists and defaults.

### Obsidian Task — Two-Pass Flow

Unlike other tasks, `obsidian.yml` on Ubuntu has interactive sub-steps (Obsidian Sync login + e2e password) that can't be automated. The task is designed to be run twice:

1. **Pass 1** (`--tags obsidian`): installs AppImage, extracts `obsidian-cli` to `~/.local/bin/obsidian`, installs nvm + Node LTS + `obsidian-headless`, writes systemd `--user` units, starts `obsidian.service`, runs `loginctl enable-linger`. No vault yet.
2. **User runs interactively**: `ob login`, `ob sync-setup --vault NAME --path ~/NAME`, then `ob sync-config --path ~/NAME --mode pull-only --configs ...` (pull-only is mandatory — bidirectional with empty defaults will overwrite cloud configs).
3. **Pass 2** (`--tags obsidian -e obsidian_vault_name=NAME`): registers the vault in `obsidian.json`, restarts Obsidian, runs `app.plugins.setEnable(true)` (loads community plugins — headless mode skips the trust prompt that would normally do this), enables `ob-sync.service`.

The systemd units run with Electron's built-in `--ozone-platform=headless` flag — no Xvfb needed. Templates live in `ansible/templates/obsidian-headless.service.j2`, `ob-sync.service.j2`, `ob-sync-wrapper.sh.j2`, `obsidian.json.j2`.

**Linux task assumes target user.** `obsidian.yml` uses `ansible_user_dir` and `systemctl --user`, so it only installs correctly as the logged-in user. This is why it is excluded from the `mmegger` flow (which runs as root and would install to `/root`): run `--tags obsidian` yourself after logging in as the target user.

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
3. If it should run during user provisioning, add an include in `mmegger.yml` (system-level, before or after `user.yml` per whether it must gate account creation) or `user.yml` (per-user); `apply:` on the parent include propagates the tag, so inner tasks need no per-task tags
4. Update the installation summary in `setup.yml`
