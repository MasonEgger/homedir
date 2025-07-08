#!/bin/bash

# Homedir Setup Script
# This script installs dotfiles and configuration files from this repository
# to your home directory, with backup and safety features.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BACKUP_DIR=""
INTERACTIVE=false
EXCLUDE_CLAUDE=false
DRY_RUN=false
VERBOSE=false

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

# Files to install (excluding .git and files starting with @)
declare -a FILES_TO_INSTALL

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Function to print usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install dotfiles from this repository to your home directory.

OPTIONS:
    -h, --help              Show this help message
    -i, --interactive       Interactive mode - confirm each file
    -b, --backup-dir DIR    Custom backup directory (default: ~/.homedir-backup-TIMESTAMP)
    -x, --exclude-claude    Exclude .claude directory from installation
    -n, --dry-run          Show what would be done without making changes
    -v, --verbose          Verbose output

EXAMPLES:
    $0                     # Install all files with automatic backup
    $0 -i                  # Interactive installation
    $0 -x                  # Install without .claude directory
    $0 -n                  # Dry run to see what would be installed

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -b|--backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        -x|--exclude-claude)
            EXCLUDE_CLAUDE=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            print_color "$RED" "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Set default backup directory if not provided
if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$HOME_DIR/.homedir-backup-$(date +%Y%m%d_%H%M%S)"
fi

# Function to find files to install
find_files_to_install() {
    local file
    
    # Find all files matching .[Xa-z]* pattern (hidden files)
    for file in "$SCRIPT_DIR"/.[Xa-z]*; do
        if [[ -e "$file" ]]; then
            local basename=$(basename "$file")
            # Exclude .git directory
            if [[ "$basename" != ".git" ]]; then
                # Exclude .claude if requested
                if [[ "$EXCLUDE_CLAUDE" == "true" && "$basename" == ".claude" ]]; then
                    continue
                fi
                FILES_TO_INSTALL+=("$basename")
            fi
        fi
    done
    
    # Find regular files (excluding README.md and CLAUDE.md as requested)
    for file in "$SCRIPT_DIR"/*; do
        if [[ -f "$file" ]]; then
            local basename=$(basename "$file")
            # Exclude documentation files and this script
            if [[ "$basename" != "README.md" && "$basename" != "CLAUDE.md" && "$basename" != "setup.sh" ]]; then
                FILES_TO_INSTALL+=("$basename")
            fi
        fi
    done
}

# Function to create backup
create_backup() {
    local file=$1
    local target="$HOME_DIR/$file"
    
    if [[ -e "$target" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            print_color "$YELLOW" "Would backup: $target -> $BACKUP_DIR/$file"
        else
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            cp -r "$target" "$BACKUP_DIR/$file"
            [[ "$VERBOSE" == "true" ]] && print_color "$BLUE" "Backed up: $target"
        fi
        return 0
    fi
    return 1
}

# Function to install a file
install_file() {
    local file=$1
    local source="$SCRIPT_DIR/$file"
    local target="$HOME_DIR/$file"
    
    # Check if we should proceed
    if [[ "$INTERACTIVE" == "true" && "$DRY_RUN" == "false" ]]; then
        echo -n "Install $file? [y/N] "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_color "$YELLOW" "Skipped: $file"
            return
        fi
    fi
    
    # Create backup if file exists
    create_backup "$file"
    
    # Install the file
    if [[ "$DRY_RUN" == "true" ]]; then
        print_color "$GREEN" "Would install: $file"
    else
        # Create parent directory if needed
        local target_dir=$(dirname "$target")
        [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"
        
        # Copy the file/directory
        cp -r "$source" "$target"
        print_color "$GREEN" "Installed: $file"
        
        # Make scripts executable if they're in .homedir
        if [[ "$file" == .homedir/* && -f "$target" ]]; then
            chmod +x "$target"
            [[ "$VERBOSE" == "true" ]] && print_color "$BLUE" "Made executable: $target"
        fi
    fi
}

# Main installation process
main() {
    print_color "$BLUE" "=== Homedir Setup Script ==="
    echo
    
    # Find files to install
    find_files_to_install
    
    if [[ ${#FILES_TO_INSTALL[@]} -eq 0 ]]; then
        print_color "$RED" "No files found to install!"
        exit 1
    fi
    
    # Show what will be installed
    print_color "$BLUE" "Files to install:"
    for file in "${FILES_TO_INSTALL[@]}"; do
        echo "  - $file"
    done
    echo
    
    # Show configuration
    print_color "$BLUE" "Configuration:"
    echo "  Home directory: $HOME_DIR"
    echo "  Backup directory: $BACKUP_DIR"
    echo "  Interactive: $INTERACTIVE"
    echo "  Exclude .claude: $EXCLUDE_CLAUDE"
    echo "  Dry run: $DRY_RUN"
    echo
    
    # Confirm before proceeding (unless interactive or dry-run)
    if [[ "$INTERACTIVE" == "false" && "$DRY_RUN" == "false" ]]; then
        echo -n "Proceed with installation? [y/N] "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_color "$YELLOW" "Installation cancelled."
            exit 0
        fi
    fi
    
    # Create backup directory if needed and not dry-run
    if [[ "$DRY_RUN" == "false" ]]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    # Install each file
    local installed=0
    local skipped=0
    local backed_up=0
    
    for file in "${FILES_TO_INSTALL[@]}"; do
        if install_file "$file"; then
            ((installed++))
        else
            ((skipped++))
        fi
    done
    
    # Summary
    echo
    print_color "$BLUE" "=== Installation Summary ==="
    print_color "$GREEN" "Installed: $installed files"
    [[ $skipped -gt 0 ]] && print_color "$YELLOW" "Skipped: $skipped files"
    if [[ "$DRY_RUN" == "false" && -d "$BACKUP_DIR" && -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        print_color "$BLUE" "Backups saved to: $BACKUP_DIR"
    fi
    
    # Post-installation message
    if [[ "$DRY_RUN" == "false" && $installed -gt 0 ]]; then
        echo
        print_color "$GREEN" "Setup complete! You may need to:"
        echo "  - Restart your shell or run: source ~/.zshrc"
        echo "  - Check that custom commands in ~/.homedir/ work as expected"
    fi
}

# Run main function
main