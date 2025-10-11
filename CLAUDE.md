# CLAUDE.md

This file provides comprehensive guidance to Claude Code (claude.ai/code) when working with this repository.

## IMMEDIATE CONTEXT FOR CLAUDE CODE

### Essential System Architecture
- **Repository Type**: macOS dotfiles automation via Makefile
- **File Strategy**: Copy configurations (repository-independent after setup)
- **Authentication**: Single sudo prompt with 1-hour session extension
- **Target Structure**: Core (`setup`, `setup-apps`) + Optional (`optional-*`) + Internal (`_*`)
- **Idempotency**: All targets safe to run multiple times

### Critical Commands
```bash
# Core environment setup
make setup         # Basic dev environment (homebrew, packages, shell, configs)
make setup-apps    # macOS applications + system settings

# Optional development environments
make optional-cloud-cli     # AWS/Azure CLI tools
make optional-docker        # Docker + colima backend
make optional-kubernetes    # minikube + kubectl + kubecolor

# Management
make backup-brewfile # Create host-specific Brewfile backup
make uninstall      # Complete removal with cleanup
```

### Dependency Chain Rules
```bash
# Authentication required for:
setup: _authenticate         # Shell changes need sudo
optional-docker: _authenticate    # System service management
optional-kubernetes: _authenticate # Cluster operations

# No authentication needed for:
setup-apps                   # User-space app installation
backup-brewfile             # Homebrew operations only
```

## TARGET IMPLEMENTATION PATTERNS

### 1. Configuration Target Pattern
```bash
_configure-app: [dependencies]
	@echo "Configuring app..."
	@# Always remove existing first
	@if [ -e ~/.apprc ]; then rm -f ~/.apprc; fi
	@# Copy from repository
	@cp app/config ~/.apprc
	@echo "App configuration copied"
```

### 2. Package Installation Pattern
```bash
_install-category: _install-homebrew
	@echo "Installing category packages..."
	@brew install package1 package2 package3
	@echo "Category packages installed"
```

### 3. Environment Verification Pattern
```bash
optional-service: _authenticate _install-homebrew
	@# Install tools
	@brew install service-cli
	@# Start and verify service
	@if ! service status >/dev/null 2>&1; then service start; fi
	@if service-cli info >/dev/null 2>&1; then
		echo "✓ Service ready"
	else
		echo "⚠ Service connection failed"
	fi
```

## PACKAGE CATEGORIZATION SYSTEM

### Core Packages (_install-packages)
- **Purpose**: Essential development tools for all users
- **Content**: bash, git, go, node@22, CLI utilities, GNU tools
- **Trigger**: Always installed via `make setup`

### Development Apps (_install-dev-apps)
- **Purpose**: Development desktop applications
- **Content**: GitHub Desktop
- **Trigger**: Installed via `make setup-apps`

### macOS Applications (_install-apps)
- **Purpose**: General macOS productivity applications
- **Content**: iTerm2, Alt-Tab, Displaperture, LinearMouse, Stats, VS Code
- **Trigger**: Installed via `make setup-apps`

### Optional Environments
- **optional-cloud-cli**: awscli, azure-cli
- **optional-docker**: docker, docker-compose, colima
- **optional-kubernetes**: kubectl, kubecolor, minikube

## FILE OPERATION MAPPINGS

### Configuration Files (Repository → System)
```
bash/bashrc → ~/.profile
vim/vimrc → ~/.vimrc
vim/plug.vim → ~/.vim/autoload/plug.vim
git/gitconfig → ~/.gitconfig
linearmouse/linearmouse.json → ~/.config/linearmouse/linearmouse.json
alt-tab/com.lwouis.alt-tab-macos.plist → ~/Library/Preferences/com.lwouis.alt-tab-macos.plist
fonts/*.ttf → ~/Library/Fonts/
```

### Temporary System Files (Auto-cleaned)
```
/etc/sudoers.d/dotfiles_temp → Sudo timeout (removed on uninstall)
```

## AUTHENTICATION STRATEGY

### When `_authenticate` Required
- Shell modification (`chsh`, editing `/etc/shells`)
- System preference changes (`defaults write -g`)
- Service management (Docker, Kubernetes)
- Any `/etc/` file modifications

### When NOT Required
- Home directory operations (`~/.config`, `~/.vimrc`)
- Homebrew operations (`brew install`, `brew bundle`)
- Directory creation in user space

### Implementation Details
```bash
_authenticate:
	@sudo -v  # Prompt for password
	@echo "Defaults timestamp_timeout=60" | sudo tee /etc/sudoers.d/dotfiles_temp
```

## UNINSTALL COMPLETENESS REQUIREMENTS

### Mandatory Cleanup Operations
```bash
uninstall:
	# Remove configuration files from home directory
	@for file in ~/.profile ~/.vimrc ~/.gitconfig; do rm -f "$$file"; done
	
	# Remove configuration directories
	@rm -rf ~/.vim ~/.config/linearmouse
	
	# Remove application preferences
	@rm -f ~/Library/Preferences/com.lwouis.alt-tab-macos.plist
	
	# Remove fonts
	@rm -f ~/Library/Fonts/UDEVGothic*.ttf
	
	# Restore system defaults
	@chsh -s /bin/bash
	@sudo sed -i '' '/\/opt\/homebrew\/bin\/bash/d' /etc/shells
	
	# Remove all packages (empty Brewfile technique)
	@mkdir -p /tmp/dotfiles-uninstall
	@touch /tmp/dotfiles-uninstall/Brewfile
	@cd /tmp/dotfiles-uninstall && brew bundle cleanup --force
	
	# Critical: Remove temporary sudo configuration
	@sudo rm -f /etc/sudoers.d/dotfiles_temp
```

## ERROR HANDLING STANDARDS

### Required Output Pattern
```bash
@echo "Starting operation..."
@if operation_succeeds; then
	echo "✓ Operation completed successfully"
else
	echo "⚠ Operation failed: specific_reason"
	echo "Troubleshooting: suggested_action"
fi
```

### Service Verification Pattern
```bash
# Always verify service status after setup
@if service_check_command >/dev/null 2>&1; then
	echo "✓ Service operational"
	service_info_command  # Show status
else
	echo "⚠ Service not responding"
	echo "Try: manual_start_command"
fi
```

## DEVELOPMENT EXTENSION GUIDELINES

### Adding New Configuration
1. **Create directory**: `mkdir new-app/`
2. **Add internal target**: `_configure-new-app: [deps]`
3. **Follow copy pattern**: Remove existing → Copy new → Confirm
4. **Add to public target**: Include in appropriate `setup*` target
5. **Update .PHONY**: Add target to declaration
6. **Implement cleanup**: Add removal logic to `uninstall`
7. **Test idempotency**: Verify safe to run multiple times

### Adding Optional Environment
1. **Create target**: `optional-new-env: _authenticate _install-homebrew`
2. **Install packages**: Use `brew install` commands
3. **Start services**: Check status, start if needed
4. **Verify connectivity**: Test functionality, provide feedback
5. **Document usage**: Add example commands in output

### Adding Package Categories
- **Never mix categories**: Each serves distinct purpose
- **Use appropriate target**: Match package type to target
- **Test installation**: Verify packages install correctly
- **Test removal**: Ensure cleanup works in uninstall

## KEY CONSTRAINTS FOR CLAUDE CODE

### Architectural Constraints
- **File copying**: Never use symbolic links
- **Single authentication**: One sudo prompt per session
- **Modular design**: Respect core/optional separation
- **Idempotency**: All operations must be repeatable

### Security Requirements
- **Temporary files**: Always clean up system modifications
- **Sudo management**: Remove `/etc/sudoers.d/dotfiles_temp` on uninstall
- **No secrets**: Never commit or log sensitive information

### User Experience Standards
- **Clear feedback**: Echo status for major operations
- **Error guidance**: Provide actionable troubleshooting
- **Unattended setup**: Minimize user interaction after initial password

### Testing Requirements
1. **Core functionality**: `make setup && make setup-apps`
2. **Optional features**: Test each `optional-*` independently
3. **Complete removal**: `make uninstall` must restore clean state
4. **Authentication flow**: Verify single password prompt works
5. **Sudo cleanup**: Confirm temporary configuration removed

## IMPLEMENTATION CHECKLIST

When modifying this repository:

- [ ] Follow target naming convention (`_internal`, `public`, `optional-*`)
- [ ] Add `_authenticate` dependency for sudo operations
- [ ] Implement corresponding cleanup in `uninstall` target
- [ ] Update `.PHONY` declaration
- [ ] Test idempotency (safe to run multiple times)
- [ ] Verify authentication works (single password prompt)
- [ ] Confirm cleanup works (check `/etc/sudoers.d/dotfiles_temp` removed)
- [ ] Update documentation (README and CLAUDE.md)

This repository provides a mature, secure, and user-friendly dotfiles automation system. Maintain these architectural decisions while extending functionality.