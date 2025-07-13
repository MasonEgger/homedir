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

- **packages**: System packages (brew/apt) and uv Python package manager
- **dotfiles**: Core dotfiles (.zshrc, .vimrc, .tmux.conf, etc.)
- **claude**: .claude directory with Claude Code settings and commands
- **homedir**: .homedir directory with custom utility scripts

## File Structure

```
ansible/
├── setup.yml           # Main playbook (orchestration only)
├── group_vars/         # Variable definitions
│   └── all.yml         # Package lists and configuration variables
├── tasks/              # Modular task definitions
│   ├── packages.yml    # Package management tasks
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