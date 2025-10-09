# CLAUDE.md

This file provides comprehensive guidance to Claude Code (claude.ai/code) when working with this repository.

## Repository Overview

**Type**: Personal dotfiles repository with automated macOS development environment setup
**Primary Interface**: Makefile-based automation system
**Architecture**: File copying (not symbolic links) for repository independence
**Target Platform**: macOS with Homebrew ecosystem

## Quick Command Reference

### Primary Commands (User-Facing)
```bash
make help          # Show available commands (default target)
make setup         # Basic environment setup
make setup-apps    # macOS applications + system settings
make setup-extra   # Additional development tools (CLI + desktop apps)
make setup-all     # Complete setup (setup + setup-extra + setup-apps)
make uninstall     # Remove all configurations and packages
make backup-brewfile # Create host-specific Brewfile backup
```

### Internal Implementation
All setup is handled through internal targets with underscore prefix:
- `_install-*`: Installation tasks (homebrew, packages, apps, fonts)
- `_configure-*`: Configuration tasks (bash, vim, git, system, vscode, linearmouse)

## Critical Architecture Decisions

### 1. File Management Strategy
**Current**: Configuration files are **copied** (not symlinked) to target locations
- **Rationale**: Removes repository dependencies after installation
- **Implication**: Changes to active configs don't sync back to repository
- **Update Process**: Modify repository → re-run appropriate make target

### 2. Package Management Dual System
**Installation**: Direct `brew install` commands in Makefile targets
**Backup**: `brewfiles/[hostname]/Brewfile` for host-specific package snapshots
- **Key Point**: Brewfiles are NOT used for installation, only for backup/reference
- **Command**: `make backup-brewfile` creates/updates host-specific backup

### 3. Target Naming Convention
**Public** (user-facing): `help`, `setup`, `setup-apps`, `setup-extra`, `setup-all`, `uninstall`, `backup-brewfile`
**Internal** (implementation): `_install-*`, `_configure-*` with underscore prefix
- **Rule**: Never use `setup` prefix for internal targets
- **Visibility**: Only public targets appear in help output

## File Structure and Mappings

### Configuration Files (copied to destinations)
```
Source → Destination
bash/bashrc → ~/.profile
vim/vimrc → ~/.vimrc
vim/plug.vim → ~/.vim/autoload/plug.vim
git/gitconfig → ~/.gitconfig
linearmouse/linearmouse.json → ~/.config/linearmouse/linearmouse.json
fonts/*.ttf → ~/Library/Fonts/
```

### Package Categories (installed via Makefile)
- **Basic packages** (_install-packages): bash, git, go, node@22, CLI utilities, GNU tools
- **Development CLI** (_install-dev-cli): kubectl, kubecolor, awscli, azure-cli, docker
- **Additional dev CLI** (_install-dev-cli-extra): lazygit, lazydocker
- **Development apps** (_install-dev-apps): Docker Desktop, GitHub Desktop
- **macOS applications** (_install-apps): iTerm2, Alt-Tab, LinearMouse, Stats, VS Code
- **System settings** (_configure-system): Global key repeat enabled
- **VS Code settings** (_configure-vscode): VS Code-specific key repeat enabled

### Directory Organization
```
dotfiles/
├── bash/           # Bash configuration
├── vim/            # Vim configuration and plugins
├── git/            # Git configuration
├── fonts/          # Font files
├── linearmouse/    # LinearMouse configuration
├── vscode/         # VS Code settings (extensions via Settings Sync)
├── brewfiles/      # Host-specific Brewfile backups
└── Makefile        # Central automation system
```

## Development Guidelines

### When Adding New Configurations

1. **Determine Scope**
   - Single application → create dedicated directory (e.g., `tmux/`, `neovim/`)
   - Related configurations → group logically (e.g., fonts covers multiple files)

2. **Implementation Pattern**
   ```bash
   # Add internal target with appropriate prefix
   _configure-newapp: [dependencies]
   	@echo "Configuring newapp..."
   	@# Remove existing configuration
   	@if [ -e ~/.newapprc ]; then rm -f ~/.newapprc; fi
   	@# Copy configuration
   	@cp newapp/config ~/.newapprc
   	@echo "Newapp configuration copied"
   ```

3. **Integration Steps**
   - Add internal target to appropriate public target dependencies
   - Add to `.PHONY` declaration
   - Implement uninstall logic in `uninstall` target
   - Update help text if adding public target
   - Document in this file and README

### Makefile Best Practices

- **Dependencies**: Use proper target dependencies (`target: dependency`)
- **Error Handling**: Check for existing files/directories before operations
- **User Feedback**: Provide clear echo messages for major operations
- **macOS Compatibility**: Test with system default `/bin/bash`
- **Cleanup**: Always implement reverse operations in `uninstall`

### Package Management

**Adding Packages**:
1. Add `brew install package-name` to appropriate `_install-*` target
2. Categorize correctly (basic/dev-cli/dev-cli-extra/dev-apps/macos-apps)
3. Test installation and uninstallation

**DO NOT**:
- Use Brewfiles for installation (they're backup-only)
- Mix package categories inappropriately
- Install packages outside Makefile system

### Testing Requirements

Before committing changes:
1. Test full installation: `make setup-all`
2. Test partial installations: `make setup`, `make setup-apps`, `make setup-extra`
3. Test uninstallation: `make uninstall`
4. Verify host-specific backup: `make backup-brewfile`
5. Test on clean macOS system if possible

## Code Quality Standards

- **No Emojis**: Never use emojis in any files
- **Consistent Formatting**: Follow existing Makefile tab/space conventions
- **Clear Documentation**: Update both CLAUDE.md and README for changes
- **Error Messages**: Provide helpful feedback for failures
- **Idempotency**: Make targets should be safe to run multiple times

## Context for AI Code Generation

When Claude Code works with this repository:

1. **Primary Goal**: Maintain and extend the automated macOS development environment setup
2. **Core Constraint**: Preserve file copying approach (not symbolic links)
3. **Extension Pattern**: Follow the internal/public target naming convention
4. **Testing Requirement**: All changes must be testable via make commands
5. **Documentation Standard**: Update both CLAUDE.md and README for user-facing changes

This repository represents a mature, well-structured dotfiles system optimized for reliability and ease of use. Maintain these architectural decisions while extending functionality.