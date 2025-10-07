# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository organized by application/tool. It focuses on macOS development and uses manual installation rather than automated scripts.

## Key Commands

### Package Management
```bash
# Install all packages from Brewfile
cd homebrew && brew bundle

# Update Brewfile with currently installed packages
brew bundle dump --force

# Install individual package and update Brewfile
brew install <package> && brew bundle dump --force
```

### Shell Configuration
```bash
# Change default shell to Homebrew bash
chsh -s /opt/homebrew/bin/bash

# Test bash configuration without affecting current session
bash --rcfile bash/bashrc
```

### Git Configuration
```bash
# Apply git configuration (must be done manually)
# Copy git/gitconfig to ~/.gitconfig or include it
```

## Architecture Overview

The repository follows a simple directory-per-application structure with no automation scripts. Key architectural decisions:

1. **Configuration Distribution**: Each application has its own directory containing configuration files that must be manually linked or copied to their target locations.

2. **Bash Configuration**: Single `bash/bashrc` file handles all shell setup including PATH configuration, prompt customization, environment variables, and aliases. No platform-specific subdirectories exist.

3. **Package Management**: `homebrew/Brewfile` serves as the single source of truth for all installed packages (56 packages including development tools, CLI utilities, and GUI applications).

4. **VS Code Integration**: Contains complete VS Code configuration including settings, keybindings, and Claude Code-specific local settings.

## Important Configuration Files

### homebrew/Brewfile
Contains 56 packages including:
- Development tools: python@3.13, go, node@22, azure-cli, awscli
- CLI utilities: ripgrep, bat, gh, kubectl, terraform, helm
- Specialized tools: kubecolor, lazydocker, kubeseal, atlas
- GUI applications: github, qlmarkdown, stats

### bash/bashrc
Comprehensive bash configuration that:
- Sets up PATH with Homebrew directories prioritized
- Configures git-aware prompt with status indicators
- Sets environment variables for development tools (kubectl, dotnet, etc.)
- Defines aliases for common commands (kubectl→kubecolor, cat→bat)
- Enables vi mode and bash completion
- Configures Claude Code environment variables

### git/gitconfig
Minimal git configuration with:
- Git LFS filter configuration
- User identity (name and email)
- Default branch set to "main"
- HTTP/1.1 version specification
- Current branch push behavior

### vscode/settings.json
VS Code configuration with Claude Code integration and development-focused settings.

## Working with This Repository

When making changes:
- Maintain the directory-per-application structure
- Update `homebrew/Brewfile` when adding new packages: `brew bundle dump --force`
- Test bash configuration changes in isolation before applying
- No automation scripts exist - all installation is manual per README.md instructions
- NEVER use emojis in code, documentation, or any files in this repository