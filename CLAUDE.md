# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository organized by application/tool. It focuses on macOS development and now provides automated installation through Makefile for complete environment setup.

## Key Commands

### Automated Setup (Preferred Method)
```bash
# Show all available commands (default)
make
make help

# Basic environment setup
make setup

# macOS applications setup
make setup-apps

# Complete environment setup including development tools
make setup-all

# Uninstall everything
make uninstall
```

### Package Management
Packages are now managed directly through Makefile targets, not via Brewfile:
```bash
# Basic packages are installed via make setup
# Development CLI tools via make setup-all
# Individual components are internal targets (not for direct use)
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

3. **Package Management**: Packages are installed directly through Makefile targets. The `brewfiles/` directory contains host-specific subdirectories (`brewfiles/[hostname]/`) for daily backups of installed packages. These Brewfiles serve as backup references and are not used by the automated Makefile setup process.

4. **VS Code Integration**: VS Code extensions managed through built-in sync functionality, separate from Homebrew package management.

5. **Flexible Organization**: Directory structure and Makefile targets organized pragmatically based on installation needs rather than rigid per-application rules.

## Important Configuration Files

### Makefile
Central automation script that provides:
- `make setup`: Basic environment setup (homebrew + packages + bash + bashrc + fonts + vim + git)
- `make setup-apps`: macOS applications and LinearMouse configuration
- `make setup-all`: Complete environment setup including development tools and apps
- `make uninstall`: Complete removal of all configurations and packages
- `make help`: Show available commands (default when running `make`)
- macOS Bash compatibility (runs on system default `/bin/bash`)
- Handles existing file cleanup, file copying, and system configuration
- Internal targets use underscore prefix and are not intended for direct user access

### Package Installation (via Makefile)
Packages are installed directly via brew commands in Makefile targets:
- **Basic packages**: bash, bash-completion, git, gh, make, go, node@22, bat, tree, jq, yq, curl, wget, watch, coreutils, findutils, diffutils, binutils, glow, cliclick, code-minimap, im-select
- **Development CLI tools**: kubectl, kubecolor, awscli, azure-cli, docker
- **Additional development CLI tools**: lazygit, lazydocker  
- **Development desktop apps**: Docker Desktop, GitHub Desktop
- **macOS applications**: iTerm2, alt-tab, displaperture, linearmouse, stats, Visual Studio Code

### bash/bashrc (copied to ~/.profile)
Comprehensive bash configuration handling PATH setup, git-aware prompt, environment variables, aliases, vi mode, and bash completion.

### vim/vimrc (copied to ~/.vimrc) and vim/plug.vim (copied to ~/.vim/autoload/plug.vim)
Vim configuration with vim-plug plugin manager. Automatically installs vim-plug and runs `:PlugInstall` during setup.

### git/gitconfig (copied to ~/.gitconfig)
Git configuration including LFS, user identity, default branch "main", and push behavior.

### fonts/ (copied to ~/Library/Fonts/)
UDEVGothicLG font family (4 files). Files are copied to system font directory.

### linearmouse/linearmouse.json (copied to ~/.config/linearmouse/)
LinearMouse configuration for mouse acceleration control.

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

### Makefile Target Naming Convention:
- **Public targets** (for user consumption): `help`, `setup`, `setup-apps`, `setup-all`, `uninstall`
- **Internal targets** (for implementation): Use underscore prefix (`_`) to indicate private/internal use
- **Internal target naming**: 
  - `_configure-*` for configuration setup (e.g., `_configure-homebrew`, `_configure-bash`)
  - `_install-*` for installation tasks (e.g., `_install-packages`, `_install-fonts`)
  - `_link-*` for symbolic link creation (e.g., `_link-bashrc`)
- **Public targets only** should be listed in help output to avoid confusion
- Never use `setup` prefix for internal targets to prevent confusion with public `setup*` targets

### Configuration Change Tracking:
Configuration files are copied to their target locations, removing repository dependencies. To update configurations after changes:
1. Modify files in the repository
2. Run appropriate setup commands (`make setup`, `make setup-apps`, or `make setup-all`)
3. This approach ensures configurations are independent and portable

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
