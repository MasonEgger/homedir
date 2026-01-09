# Ansible Homedir Setup

This modular ansible playbook allows you to install different components of your homedir setup independently.

## Usage

### Default Mode: Install Everything for Existing User
```bash
ansible-playbook setup.yml
```

### New User Creation Mode (Linux Only)

This mode creates a brand new user account and sets up the complete environment from scratch. **This mode is only supported on Linux (Debian/Ubuntu) systems.**

#### Create New User and Setup Environment
```bash
# Run as root to create user 'mmegger' with full environment setup
sudo ansible-playbook setup.yml --extra-vars "create_user=true"
```

#### What This Does:
1. **Creates new user account** with:
   - Username: `mmegger` (configurable)
   - Shell: `/bin/zsh`
   - Groups: `sudo`, `docker`
   - Temporary password: `ChangeMe123!` (must be changed on first login)

2. **Configures SSH access**:
   - Copies root's SSH public key to new user's authorized_keys (if exists)
   - Downloads additional SSH keys from `sshid.io/mmegger`
   - Sets proper permissions (700 for .ssh directory, 600 for authorized_keys)

3. **Installs all components** for the new user:
   - System packages
   - Core dotfiles (.zshrc, .vimrc, .tmux.conf, .gitconfig)
   - .claude directory
   - .homedir scripts
   - Vale configuration
   - Git hooks
   - Oh My Zsh

4. **Sets up proper permissions** so all files are owned by the new user

#### Customization Options
```bash
# Custom username
sudo ansible-playbook setup.yml --extra-vars "create_user=true new_user_name=johndoe"

# Custom shell
sudo ansible-playbook setup.yml --extra-vars "create_user=true new_user_shell=/bin/bash"

# Custom temporary password (recommended to use ansible-vault for security)
sudo ansible-playbook setup.yml --extra-vars "create_user=true new_user_temp_password=SecurePass123!"
```

#### Security Notes
- **Password Storage**: By default, the temporary password is stored in plain text in `group_vars/all.yml`. For better security, use `ansible-vault` to encrypt the variable.
- **Password Change**: The user will be forced to change the password on first login.
- **sudo Access**: The user is added to the sudo group and will have full root access.

#### Limitations
- **Linux Only**: This mode only works on Linux (Debian/Ubuntu). If attempted on macOS, it will fail with a clear error message.
- **Requires Root**: You must run the playbook with `sudo` or as root.
- **Single User**: Creates one user per run. To create multiple users, run the playbook multiple times with different usernames.

#### After User Creation
```bash
# SSH access is automatically configured:
# - Root's SSH key copied (if available)
# - Additional keys downloaded from sshid.io/mmegger

# You can SSH directly to the machine as the new user
ssh mmegger@hostname

# Or switch to the user locally
su - mmegger

# You will be prompted to change the temporary password
# Follow the prompts to set a new secure password

# Start using your environment
# All custom commands (uuid, cdr, etc.) should work immediately
```

**Note**: The SSH key from `sshid.io/mmegger` will use the username specified in `new_user_name` variable. If you use a custom username, keys will be fetched from `sshid.io/<custom-username>`.

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

- **user**: User account creation (Linux only, requires `create_user=true`)
- **packages**: System packages (brew/apt) and uv Python package manager
- **dotfiles**: Core dotfiles (.zshrc, .vimrc, .tmux.conf, etc.)
- **claude**: .claude directory with Claude Code settings and commands
- **homedir**: .homedir directory with custom utility scripts
- **vale**: Vale prose linter and configuration
- **git-hooks**: Global git hooks (pre-commit for AI session tracking)

## File Structure

```
ansible/
├── setup.yml           # Main playbook (orchestration only)
├── group_vars/         # Variable definitions
│   └── all.yml         # Package lists, user config, and configuration variables
├── tasks/              # Modular task definitions
│   ├── user.yml        # User account creation (Linux only)
│   ├── packages.yml    # Package management tasks
│   ├── dotfiles.yml    # Core dotfiles installation
│   ├── claude.yml      # .claude directory installation
│   ├── homedir.yml     # .homedir directory installation
│   ├── vale.yml        # Vale prose linter installation
│   └── git-hooks.yml   # Global git hooks installation
├── templates/          # Jinja2 templates
│   └── gitconfig.j2    # Git configuration template
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