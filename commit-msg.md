## Integrate Vale prose linter with custom mmegger writing styles

Added Vale prose linter configuration with custom writing style rules (mmegger) to enable consistent technical writing checks across all machines. The configuration is installed globally and managed through Ansible for easy deployment.

### What Changed

**Vale Configuration:**
- Created `.vale/` directory with custom mmegger style rules (26 YAML files)
- Added `.vale.ini` global configuration pointing to `.vale/styles`
- Supports Markdown, reStructuredText, and AsciiDoc formats
- Configured to show all alert levels (errors, warnings, suggestions)
- Includes vocabularies, filters, scripts, and views for comprehensive style checking
- Style name: `mmegger` (personalized, not tied to external sources)

**Ansible Integration:**
- Created `ansible/tasks/vale.yml` for modular Vale installation
- Updated `ansible/setup.yml` to include Vale tasks with `--tags vale` support
- Added `vale` to `apt_packages` in `ansible/group_vars/all.yml:59` for Linux support
- Updated installation summary to show Vale configuration status
- Added post-install verification instruction: `vale --version`

**Agent Creation:**
- Created `.claude/agents/copy-editor.md` agent for prose review
- Agent identifies as "copy editor and style editor" specializing in Vale-based checking
- Uses mmegger writing style configuration for consistency
- Proactively reviews documentation and prose content
- Tool-agnostic naming (not tied to Vale specifically)

**Migration:**
- Migrated all style rules from external bphogan-vale repository
- Renamed to mmegger style for personalization
- Removed bphogan references throughout
- All Vale styles now version-controlled within homedir repository

### Why These Changes

1. **Personalized**: Custom mmegger style name instead of external bphogan reference
2. **Version Control**: Vale styles tracked in repository, no external dependencies
3. **No Internet Required**: No need for `vale sync` during setup
4. **Cross-Platform**: Works on both macOS (Homebrew) and Linux (apt)
5. **Modular Installation**: Can install Vale independently with `ansible-playbook --tags vale`
6. **Consistent Writing**: Same style checks apply across all machines and projects
7. **Copy Editing Agent**: Proactive prose review during documentation work

### Directory Structure

```
.vale/
└── styles/
    ├── mmegger/              # 26 YAML rule files
    └── config/               # Supporting files
        ├── filters/
        ├── scripts/
        ├── views/
        └── vocabularies/
            └── mmegger/
                ├── accept.txt
                └── reject.txt
```

### Installation Usage

After pulling these changes:

```bash
# Install only Vale configuration
ansible-playbook ansible/setup.yml --tags vale

# Install packages and Vale together
ansible-playbook ansible/setup.yml --tags packages,vale

# Install everything
ansible-playbook ansible/setup.yml
```

### Testing Performed

- Ansible syntax validation: ✅ Passed
- Dry run (`--check --diff`): ✅ Showed correct changes
- Full installation: ✅ Files copied to `~/.vale/` and `~/.vale.ini`
- Vale functionality: ✅ Successfully lints files using mmegger rules
- Configuration recognition: ✅ `vale ls-config` shows mmegger vocabulary and styles
- Global config: ✅ Works from any directory
- Style naming: ✅ All rules show as `mmegger.RuleName` (not bphogan)

### Files Added/Modified

**Added:**
- `.vale/` - New directory with all mmegger style rules and config
- `.vale.ini` - Vale configuration file
- `ansible/tasks/vale.yml` - Ansible task file for Vale installation
- `.claude/agents/copy-editor.md` - Copy editing agent using Vale

**Modified:**
- `ansible/setup.yml` - Added Vale task inclusion and updated summary
- `ansible/group_vars/all.yml` - Added vale to apt_packages (line 59)

### Style Rules Included

The mmegger style includes 26 rules covering:
- Writing clarity (avoid condescending language, weasel words, wordy phrases)
- Grammar (Oxford comma, sentence capitalization, passive voice)
- Technical writing (Latin abbreviations, first-person usage, acronym definitions)
- Formatting (heading capitalization, paragraph length, title length)
- Code quality (line length in code blocks)
- Readability metrics (Flesch Reading Ease scores)
