# Ansible Homedir Setup

This modular ansible playbook allows you to install different components of your homedir setup independently.

## Usage

### Install Everything
```bash
ansible-playbook setup.yml
```

### Install Specific Components

#### Install packages only
```bash
ansible-playbook setup.yml --tags packages
```

#### Install core dotfiles only (excludes .claude and .homedir)
```bash
ansible-playbook setup.yml --tags dotfiles
```

#### Install .claude directory only
```bash
ansible-playbook setup.yml --tags claude
```

#### Install .homedir directory only
```bash
ansible-playbook setup.yml --tags homedir
```

#### Install multiple components
```bash
ansible-playbook setup.yml --tags packages,dotfiles
ansible-playbook setup.yml --tags claude,homedir
```

### Check Mode (Dry Run)
Add `--check` to any command to see what would change without making actual changes. Ansible modules automatically show predicted changes:
```bash
ansible-playbook setup.yml --tags dotfiles --check
ansible-playbook setup.yml --check  # Check all components
```

### Detailed Change Preview
Add `--diff` with `--check` to see detailed before/after file changes:
```bash
ansible-playbook setup.yml --tags dotfiles --check --diff
ansible-playbook setup.yml --check --diff  # Show diffs for all components
```

### Interactive Mode
Add `--extra-vars "interactive=true"` to be prompted before installation:
```bash
ansible-playbook setup.yml --extra-vars "interactive=true"
```

### Exclude .claude Directory
Add `--extra-vars "exclude_claude=true"` to skip .claude installation even when running all tasks:
```bash
ansible-playbook setup.yml --extra-vars "exclude_claude=true"
```

## Components

- **packages**: System packages (brew/apt). Node is deliberately *not* installed from apt (Ubuntu ships an ancient node 18); see **user-tools**.
- **user-tools**: Per-user tools installed via curl scripts and npm (Oh My Zsh, Claude Code CLI, uv, Node, Todoist CLI, pnpm). On Ubuntu/Debian, Node comes from **nvm** (Node LTS, currently 24), because apt's node is too old for the Todoist CLI (needs node ≥24); macOS gets a current node from the brew `node` package. nvm's prefix is user-writable, so `npm install -g` needs no sudo. Interactive nvm sourcing is written to `~/.zshrc.local` (the OS-specific, non-clobbered dotfile), not the cross-OS tracked `.zshrc`. The Todoist CLI (`@doist/todoist-cli`) provides the `td` binary, invoked as `todo` in the shell to sidestep the `td=tmux detach` alias.

  **Headless auth:** the CLI stores its token in the system keyring by default, which fails on a headless box with no Secret Service daemon (`AUTH_STORE_WRITE_FAILED`). Authenticate with the plaintext store instead, which writes the token to the CLI's config file: `todo auth login --credential-store plaintext` (OAuth) or `todo auth token <API_TOKEN> --credential-store plaintext` (personal token from Todoist → Settings → Integrations → Developer). The `--credential-store` flag is only needed at store time; reads find the token automatically afterward. This is a per-user auth step, not something ansible provisions.
- **dotfiles**: Core dotfiles (.zshrc, .vimrc, .tmux.conf, etc.)
- **claude**: .claude directory with Claude Code settings and commands
- **homedir**: .homedir directory with custom utility scripts
- **obsidian**: Obsidian — desktop app on macOS (Homebrew cask), headless server setup on Ubuntu (AppImage + Electron `--ozone-platform=headless` + nvm/Node + obsidian-headless + systemd `--user` services)

## Obsidian on Ubuntu (headless)

The Linux flow installs the official AppImage to `~/.local/share/Obsidian/`, extracts the bundled `obsidian-cli` binary to `~/.local/bin/obsidian`, installs nvm + Node LTS + the official `obsidian-headless` (`ob`) npm package, and writes two systemd `--user` services. The `ob login` and `ob sync-setup` steps remain interactive.

```bash
# First pass: install everything, leave services running with no vault
ansible-playbook setup.yml --tags obsidian

# Then, on the target machine, run the interactive sync setup:
ob login
ob sync-list-remote
ob sync-setup --vault YOURVAULT --path ~/YOURVAULT --device-name $(hostname)
ob sync-config --path ~/YOURVAULT --mode pull-only \
  --configs community-plugin,community-plugin-data,core-plugin,core-plugin-data,app,hotkey,appearance
ob sync --path ~/YOURVAULT   # initial pull

# Second pass: finish wiring (registers vault in obsidian.json, enables ob-sync.service, loads plugins)
ansible-playbook setup.yml --tags obsidian -e obsidian_vault_name=YOURVAULT
```

**Important — pull-only mode.** Set `--mode pull-only` on `ob sync-config` so the headless server can never push its (empty) default configs back to your laptop's source-of-truth setup. The server downloads from cloud only.

## File Structure

```
ansible/
├── setup.yml           # Main playbook (orchestration only)
├── group_vars/         # Variable definitions
│   └── all.yml         # Package lists and configuration variables
├── tasks/              # Modular task definitions
│   ├── packages.yml    # Package management tasks
│   ├── user-tools.yml  # Per-user tools (Oh My Zsh, Claude CLI, uv, Todoist CLI, pnpm)
│   ├── dotfiles.yml    # Core dotfiles installation
│   ├── claude.yml      # .claude directory installation
│   └── homedir.yml     # .homedir directory installation
├── ansible.cfg         # Ansible configuration
├── hosts              # Inventory file (localhost)
├── requirements.yml   # Ansible requirements
└── README.md          # This documentation
```

## Architecture

### Variable Organization
- **`group_vars/all.yml`**: Contains all package definitions and default configuration
  - `brew_packages`: macOS packages installed via Homebrew
  - `apt_packages`: Ubuntu/Debian packages installed via apt
  - Default settings: `interactive`, `exclude_claude`, `verbose`
  - Backup and path configuration

### Task Modularity  
- **`setup.yml`**: Main orchestrator that loads variables and includes task files
- **`tasks/*.yml`**: Individual task files for each component
  - Each can be executed independently with `--tags`
  - Uses variables from `group_vars/all.yml`
  - Supports Ansible's built-in `--check` mode

### Benefits
- **Clean separation**: Variables, tasks, and orchestration are separate
- **Easy maintenance**: Add packages by editing `group_vars/all.yml`
- **Flexible execution**: Install only what you need with tags
- **Standard practices**: Follows Ansible conventions