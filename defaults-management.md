# macOS Defaults Management Design

This document outlines the design for managing macOS `defaults` commands within the dotfiles automation system.

## Design Overview

### Architecture
- **Flat file structure**: All configuration files in single `defaults/` directory
- **Simple format**: One `defaults` command per line in `.conf` files
- **Makefile integration**: Single target to apply all defaults configurations
- **No backup/restore**: Follows dotfiles principle of clean state rebuilding

### Directory Structure
```
defaults/
├── system.conf          # Global system settings (-g domain)
├── dock.conf           # Dock configuration
├── finder.conf         # Finder configuration
├── trackpad.conf       # Trackpad settings
├── keyboard.conf       # Keyboard settings
├── vscode.conf         # VS Code specific settings
├── terminal.conf       # Terminal.app settings
├── safari.conf         # Safari settings
└── xcode.conf          # Xcode settings
```

## File Format Specification

### Configuration File Format (.conf)
- **Extension**: `.conf`
- **Content**: One `defaults` command per line
- **Comments**: Lines starting with `#` are ignored
- **Empty lines**: Ignored during processing

### Example Configuration Files

**system.conf**
```bash
# Global macOS system settings
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
defaults write -g NSTableViewDefaultSizeMode -int 2
```

**vscode.conf**
```bash
# VS Code specific settings
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCode TSCoding.terminal.integrated.shell.osx "/opt/homebrew/bin/bash"
```

**dock.conf**
```bash
# Dock configuration
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock minimize-to-application -bool true
```

**finder.conf**
```bash
# Finder configuration
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
```

## Makefile Integration

### Target Implementation
```bash
# Configure macOS defaults settings
_configure-defaults:
	@echo "Configuring macOS defaults settings..."
	@for conf in defaults/*.conf; do \
		if [ -f "$$conf" ]; then \
			echo "Applying $$(basename "$$conf")..."; \
			while read -r cmd; do \
				[ -z "$$cmd" ] || [[ "$$cmd" =~ ^# ]] || eval "$$cmd"; \
			done < "$$conf"; \
		fi; \
	done
	@echo "macOS defaults settings configured"
```

### Integration Points
- **Add to setup-apps**: Include `_configure-defaults` in `setup-apps` target dependencies
- **Update .PHONY**: Add `_configure-defaults` to .PHONY declaration
- **Uninstall support**: No specific cleanup needed (follows clean rebuild principle)

### Modified setup-apps Target
```bash
setup-apps: _install-apps _install-dev-apps _configure-linearmouse _configure-alt-tab _configure-defaults _configure-system _configure-vscode
	@echo "macOS applications and development desktop applications setup complete!"
```

## Naming Conventions

### File Naming Rules
- **Lowercase**: All filenames in lowercase
- **Descriptive**: Clear indication of purpose (e.g., `dock.conf`, `finder.conf`)
- **App names**: Use recognizable app names when possible
- **Collision handling**: Use abbreviations or prefixes when needed
  - `safari.conf` → `sfr.conf` (if collision occurs)
  - `vscode.conf` → `code.conf` (alternative naming)

### Command Organization
- **Group by domain**: Related settings in same file
- **Logical order**: Most important settings first
- **Consistent formatting**: Same parameter types grouped together

## Implementation Guidelines for Claude Code

### When Implementing This System

1. **Create defaults directory**: `mkdir defaults/`

2. **Migrate existing settings**: Move current `defaults write` commands from Makefile to appropriate `.conf` files
   - `_configure-system` settings → `system.conf`
   - `_configure-vscode` settings → `vscode.conf`

3. **Add Makefile target**: Implement `_configure-defaults` target as specified above

4. **Update dependencies**: Add `_configure-defaults` to `setup-apps` target

5. **Update .PHONY**: Add new target to .PHONY declaration

6. **Remove old targets**: Delete `_configure-system` and app-specific defaults targets from Makefile

### File Creation Pattern
```bash
# Create configuration file
cat > defaults/newapp.conf << 'EOF'
# NewApp configuration
defaults write com.company.newapp setting1 -bool true
defaults write com.company.newapp setting2 -string "value"
EOF
```

### Testing Approach
- **Individual files**: Test each `.conf` file independently
- **Full integration**: Test complete `_configure-defaults` target
- **Idempotency**: Verify safe multiple executions
- **Error handling**: Ensure malformed lines don't break entire process

## Design Rationale

### Why Flat Structure
- **Simplicity**: No directory navigation needed
- **Clarity**: All configuration files visible at once
- **Maintenance**: Easy to add/remove/modify configurations
- **Consistency**: Aligns with existing dotfiles flat structure

### Why .conf Extension
- **Clear purpose**: Immediately identifiable as configuration
- **Standard practice**: Common in Unix/Linux environments
- **Tool compatibility**: Works with existing text processing tools

### Why No Backup/Scripts
- **Dotfiles philosophy**: Clean state rebuilding preferred over backup/restore
- **Simplicity**: Reduces complexity and maintenance overhead
- **Consistency**: Follows existing dotfiles repository patterns
- **Reliability**: Fewer components mean fewer potential failure points

## Future Considerations

### Potential Enhancements
- **Conditional application**: Apply settings based on macOS version
- **User customization**: Override mechanism for personal preferences
- **Validation**: Check if settings are applied correctly
- **Documentation**: Auto-generate documentation from .conf files

### Migration Path
Current implementation in Makefile can be gradually migrated to this system without breaking existing functionality.
