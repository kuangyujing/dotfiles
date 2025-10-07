# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository organized by application/tool. It focuses on macOS development and now provides automated installation through Makefile for complete environment setup.

## Key Commands

### Automated Setup (Preferred Method)
```bash
# Complete environment setup
make setup

# Individual components
make setup-homebrew   # Install Homebrew
make install-packages # Install packages from Brewfile
make setup-bash       # Setup Homebrew Bash as default shell
make link-bashrc      # Create bashrc symbolic link
make install-fonts    # Copy fonts to ~/Library/Fonts
make setup-vim        # Setup Vim configuration and plugins
make setup-git        # Setup Git configuration

# Uninstall everything
make uninstall

# Show all available commands
make help
```

### Package Management
```bash
# Install all packages from Brewfile
cd homebrew && brew bundle

# Update Brewfile with currently installed packages (excluding VS Code extensions)
brew bundle dump --force --no-vscode

# Install individual package and update Brewfile
brew install <package> && brew bundle dump --force --no-vscode
```

### Manual Configuration (Legacy)
```bash
# Change default shell to Homebrew bash
chsh -s /opt/homebrew/bin/bash

# Test bash configuration without affecting current session
bash --rcfile bash/bashrc
```

## Architecture Overview

The repository follows a flexible directory structure with automated Makefile-based installation. Key architectural decisions:

1. **Automated Configuration**: Makefile provides complete automation for environment setup using symbolic links and file copying.

2. **Symbolic Link Strategy**: Most configuration files use symbolic links to enable automatic synchronization between repository and active configurations. Changes made through applications are automatically reflected in the working tree.

3. **Package Management**: `homebrew/Brewfile` serves as single source of truth for all installed packages. Created with `--no-vscode` to exclude VS Code extensions.

4. **VS Code Integration**: VS Code extensions managed through built-in sync functionality, separate from Homebrew package management.

5. **Flexible Organization**: Directory structure and Makefile targets organized pragmatically based on installation needs rather than rigid per-application rules.

## Important Configuration Files

### Makefile
Central automation script that provides:
- `make setup`: Complete environment setup (homebrew + packages + bash + bashrc + fonts + vim + git)
- `make uninstall`: Complete removal of all configurations and packages
- Individual setup targets for granular control
- macOS Bash compatibility (runs on system default `/bin/bash`)
- Handles existing file cleanup, symbolic link creation, and system configuration

### homebrew/Brewfile
Contains 56+ packages including development tools, CLI utilities, specialized tools, and GUI applications. Created with `--no-vscode` to exclude VS Code extensions.

### bash/bashrc (→ ~/.profile)
Comprehensive bash configuration handling PATH setup, git-aware prompt, environment variables, aliases, vi mode, and bash completion.

### vim/vimrc (→ ~/.vimrc) and vim/plug.vim (→ ~/.vim/autoload/plug.vim)
Vim configuration with vim-plug plugin manager. Automatically installs vim-plug and runs `:PlugInstall` during setup.

### git/gitconfig (→ ~/.gitconfig)
Git configuration including LFS, user identity, default branch "main", and push behavior.

### fonts/ (copied to ~/Library/Fonts/)
UDEVGothicLG font family (4 files). Files are copied, not linked, to system font directory.

### vscode/settings.json
VS Code configuration with Claude Code integration and development-focused settings. VS Code extensions managed separately via Settings Sync.

## Working with This Repository

### When making changes:
- Maintain the directory-per-application structure
- Update `homebrew/Brewfile` when adding new packages: `brew bundle dump --force --no-vscode`
- Test configurations before committing (especially bash configuration changes)
- Use `make setup` for automated installation, not manual steps
- NEVER use emojis in code, documentation, or any files in this repository

### For Claude Code maintenance:
- The Makefile is the primary automation mechanism - all new installation logic should be added there
- When adding new application configurations, follow the symbolic link pattern for automatic synchronization
- Create Makefile targets and directories based on practical needs and logical groupings - not necessarily one target per application (e.g., fonts installation covers multiple files, bash setup includes shell configuration)
- Directory structure should be organized pragmatically based on the specific situation and configuration complexity
- Always implement corresponding uninstall logic in the `uninstall` target
- Test all Makefile changes on macOS with system default Bash (`/bin/bash`)
- Use absolute paths in symbolic links: `ln -s "$(pwd)/path/to/file" ~/target`
- Handle existing files/directories by removing them before creating links
- Fonts should be copied, not linked, to `~/Library/Fonts/`
- System changes (like shell configuration) should be reversible in the uninstall target

### Configuration Change Tracking:
Symbolic links enable automatic synchronization between active configurations and repository, providing real-time tracking and seamless multi-machine synchronization without manual copying.

### Future Development:
When adding new tools or configurations, approach should be determined based on the specific situation:
1. **Directory Organization**: Create directories as needed - may be per-application (e.g., `neovim/`, `tmux/`) or grouped by function, depending on configuration complexity and logical relationships
2. **Makefile Targets**: Create targets based on installation needs and logical groupings rather than strict one-per-application rule (e.g., `install-fonts` handles multiple font files, `setup-bash` covers shell configuration)
3. **Implementation Steps**:
   - Add configuration files to appropriate directory structure
   - Create setup target(s) in Makefile with symbolic link creation
   - Add removal logic to `uninstall` target
   - Include new target(s) in main `setup` dependency chain as appropriate
   - Update help text in Makefile
   - Document the new configuration in this file and README.md

The goal is practical organization that serves actual installation and maintenance needs rather than rigid structural rules.
