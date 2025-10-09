# dotfiles Makefile for macOS development environment setup

.PHONY: help setup setup-apps setup-extra setup-all uninstall backup-brewfile _authenticate _install-homebrew _install-packages _install-dev-cli _install-dev-cli-extra _install-dev-apps _configure-default-sh _configure-bash _install-fonts _configure-vim _configure-git _configure-system _configure-vscode _install-apps _configure-linearmouse

# Default target
help:
	@echo "Available targets:"
	@echo "  setup     - Basic environment setup (homebrew + packages + bash + bashrc + fonts + vim + git)"
	@echo "  setup-apps - Setup macOS applications and LinearMouse configuration"
	@echo "  setup-extra - Install additional development tools (CLI + desktop apps)"
	@echo "  setup-all - Complete environment setup including development tools and apps"
	@echo "  uninstall - Remove all configurations, packages, and restore defaults"
	@echo "  backup-brewfile - Create host-specific Brewfile backup"
	@echo "  help      - Show this help message"

# Authenticate sudo once for the entire session
_authenticate:
	@echo "Authenticating sudo access for 1 hour..."
	@sudo -v
	@# Extend sudo timeout to 1 hour for this session
	@echo "Defaults timestamp_timeout=60" | sudo tee /etc/sudoers.d/dotfiles_temp > /dev/null
	@echo "Sudo authentication successful (valid for 1 hour)"

# Basic setup
setup: _authenticate _install-homebrew _install-packages _configure-default-sh _configure-bash _install-fonts _configure-vim _configure-git
	@echo ""
	@echo "=================================================="
	@echo "Basic environment setup complete!"
	@echo ""
	@echo "The following has been configured:"
	@echo "  - Homebrew installation"
	@echo "  - Basic development packages"
	@echo "  - Homebrew Bash as default shell"
	@echo "  - Bash configuration (bashrc -> ~/.profile)"
	@echo "  - Font installation to ~/Library/Fonts"
	@echo "  - Vim configuration and plugins"
	@echo "  - Git configuration"
	@echo ""
	@echo "You can now close Terminal.app safely."
	@echo "Next time you open a terminal, the new environment"
	@echo "will be active with all configurations applied."
	@echo "=================================================="

# Complete setup including development tools
setup-all: setup setup-extra setup-apps
	@echo ""
	@echo "=================================================="
	@echo "Complete environment setup with development tools finished!"
	@echo ""
	@echo "The following has been configured:"
	@echo "  - Homebrew installation"
	@echo "  - Basic development packages"
	@echo "  - Development CLI tools"
	@echo "  - Additional development CLI tools"
	@echo "  - Development desktop applications"
	@echo "  - Homebrew Bash as default shell"
	@echo "  - Bash configuration (bashrc -> ~/.profile)"
	@echo "  - Font installation to ~/Library/Fonts"
	@echo "  - Vim configuration and plugins"
	@echo "  - Git configuration"
	@echo "  - macOS applications and LinearMouse configuration"
	@echo ""
	@echo "You can now close Terminal.app safely."
	@echo "Next time you open a terminal, the new environment"
	@echo "will be active with all configurations applied."
	@echo "=================================================="

# Install Homebrew if not already installed
_install-homebrew:
	@echo "Configuring Homebrew..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Homebrew is already installed"; \
	else \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "Homebrew installed successfully"; \
	fi

# Install packages using brew install commands
_install-packages: _install-homebrew
	@echo "Installing development packages..."
	@# Core Tools
	@brew install bash bash-completion git gh make
	@# Development Languages
	@brew install go node@22
	@# CLI Utilities
	@brew install bat tree jq yq curl wget watch
	@# GNU Utilities
	@brew install coreutils findutils diffutils binutils
	@# Specialized Tools
	@brew install glow cliclick code-minimap
	@# Add tap and install im-select
	@brew tap daipeihust/tap
	@brew install daipeihust/tap/im-select
	@echo "Packages installed successfully"

# Install development CLI tools
_install-dev-cli: _install-homebrew
	@echo "Installing development CLI tools..."
	@# Kubernetes tools
	@brew install kubectl kubecolor
	@# Cloud CLI tools
	@brew install awscli azure-cli
	@# Container tools
	@brew install docker
	@echo "Development CLI tools installed successfully"

# Install additional development CLI tools
_install-dev-cli-extra: _install-homebrew
	@echo "Installing additional development CLI tools..."
	@# Git tools
	@brew install lazygit
	@# Docker tools
	@brew install lazydocker
	@echo "Additional development CLI tools installed successfully"

# Install development desktop applications
_install-dev-apps: _install-homebrew
	@echo "Installing development desktop applications..."
	@# Development applications
	@brew install --cask docker
	@brew install --cask github
	@echo "Development desktop applications installed successfully"

# Configure Homebrew bash as default shell
_configure-default-sh: _install-packages
	@echo "Configuring Homebrew bash..."
	@# Check if Homebrew bash is already in /etc/shells
	@if grep -q "/opt/homebrew/bin/bash" /etc/shells 2>/dev/null; then \
		echo "Homebrew bash is already registered in /etc/shells"; \
	else \
		echo "Adding Homebrew bash to /etc/shells..."; \
		echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells; \
		echo "Homebrew bash added to /etc/shells"; \
	fi
	@# Check current shell and change if needed
	@current_shell=$$(dscl . -read ~/ UserShell | awk '{print $$2}'); \
	if [ "$$current_shell" = "/opt/homebrew/bin/bash" ]; then \
		echo "User shell is already set to Homebrew bash"; \
	else \
		echo "Changing default shell to Homebrew bash..."; \
		chsh -s /opt/homebrew/bin/bash; \
		echo "Default shell changed to Homebrew bash"; \
		echo "Please restart your terminal or run 'exec /opt/homebrew/bin/bash' to use the new shell"; \
	fi

# Copy bashrc configuration
_configure-bash:
	@echo "Configuring bashrc..."
	@# Remove existing shell configuration files
	@for file in ~/.profile ~/.bashrc ~/.bash_profile ~/.bash_logout ~/.zshrc ~/.zprofile; do \
		if [ -e "$$file" ]; then \
			echo "Removing existing $$file"; \
			rm -f "$$file"; \
		fi; \
	done
	@# Copy configuration file
	@cp bash/bashrc ~/.profile
	@echo "Bashrc configuration copied to ~/.profile"

# Install fonts
_install-fonts:
	@echo "Installing fonts..."
	@mkdir -p ~/Library/Fonts
	@cp fonts/*.ttf ~/Library/Fonts/
	@echo "Fonts copied to ~/Library/Fonts"

# Configure vim
_configure-vim:
	@echo "Configuring vim..."
	@# Remove existing vim configuration files
	@for file in ~/.vimrc ~/.vim; do \
		if [ -e "$$file" ]; then \
			echo "Removing existing $$file"; \
			rm -rf "$$file"; \
		fi; \
	done
	@# Create ~/.vim/autoload directory
	@mkdir -p ~/.vim/autoload
	@# Copy configuration files
	@cp vim/vimrc ~/.vimrc
	@cp vim/plug.vim ~/.vim/autoload/plug.vim
	@echo "Vim configuration files copied:"
	@echo "  ~/.vimrc"
	@echo "  ~/.vim/autoload/plug.vim"

# Configure git
_configure-git:
	@echo "Configuring git..."
	@# Remove existing git configuration
	@if [ -e ~/.gitconfig ]; then \
		echo "Removing existing ~/.gitconfig"; \
		rm -f ~/.gitconfig; \
	fi
	@# Copy configuration file
	@cp git/gitconfig ~/.gitconfig
	@echo "Git configuration copied to ~/.gitconfig"

# Configure system settings
_configure-system:
	@echo "Configuring system settings..."
	@# Enable key repeat globally for all applications
	@defaults write -g ApplePressAndHoldEnabled -bool false
	@echo "Global key repeat enabled for all applications"

# Configure VS Code
_configure-vscode:
	@echo "Configuring VS Code..."
	@# Enable key repeat for VS Code (disable press and hold)
	@defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	@echo "VS Code key repeat enabled (ApplePressAndHoldEnabled disabled)"

# Install macOS applications
_install-apps:
	@echo "Installing macOS applications..."
	@brew install --cask iterm2
	@brew install --cask alt-tab
	@brew install --cask displaperture
	@brew install --cask linearmouse
	@brew install --cask stats
	@brew install --cask visual-studio-code
	@echo "macOS applications installed successfully"

# Configure LinearMouse
_configure-linearmouse:
	@echo "Configuring LinearMouse..."
	@# Remove existing LinearMouse configuration
	@if [ -e ~/.config/linearmouse ]; then \
		echo "Removing existing ~/.config/linearmouse"; \
		rm -rf ~/.config/linearmouse; \
	fi
	@# Create ~/.config directory if it doesn't exist
	@mkdir -p ~/.config/linearmouse
	@# Copy configuration file
	@cp linearmouse/linearmouse.json ~/.config/linearmouse/
	@echo "LinearMouse configuration copied to ~/.config/linearmouse/"

# Setup macOS applications and LinearMouse configuration
setup-apps: _install-apps _configure-linearmouse _configure-system _configure-vscode
	@echo "macOS applications and LinearMouse configuration setup complete!"

# Setup additional development tools
setup-extra: _authenticate _install-homebrew _install-dev-cli _install-dev-cli-extra _install-dev-apps
	@echo "Additional development tools setup complete!"

# Uninstall all configurations and packages
uninstall:
	@echo ""
	@echo "=================================================="
	@echo "Uninstalling dotfiles environment..."
	@echo "=================================================="
	@echo ""
	@# Remove symbolic links
	@echo "Removing symbolic links..."
	@for file in ~/.profile ~/.vimrc ~/.gitconfig; do \
		if [ -L "$$file" ]; then \
			echo "Removing symbolic link $$file"; \
			rm -f "$$file"; \
		fi; \
	done
	@# Remove vim configuration directory
	@if [ -d ~/.vim ]; then \
		echo "Removing ~/.vim directory"; \
		rm -rf ~/.vim; \
	fi
	@# Remove installed fonts
	@echo "Removing installed fonts..."
	@for font in UDEVGothicLG-Bold.ttf UDEVGothicLG-BoldItalic.ttf UDEVGothicLG-Italic.ttf UDEVGothicLG-Regular.ttf; do \
		if [ -f ~/Library/Fonts/$$font ]; then \
			echo "Removing ~/Library/Fonts/$$font"; \
			rm -f ~/Library/Fonts/$$font; \
		fi; \
	done
	@# Restore default shell
	@echo "Restoring default shell to /bin/bash..."
	@chsh -s /bin/bash
	@# Remove Homebrew bash from /etc/shells
	@if grep -q "/opt/homebrew/bin/bash" /etc/shells 2>/dev/null; then \
		echo "Removing Homebrew bash from /etc/shells..."; \
		sudo sed -i '' '/\/opt\/homebrew\/bin\/bash/d' /etc/shells; \
	fi
	@# Uninstall all Homebrew packages
	@echo "Uninstalling all Homebrew packages..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Creating empty Brewfile for cleanup..."; \
		mkdir -p /tmp/dotfiles-uninstall; \
		touch /tmp/dotfiles-uninstall/Brewfile; \
		cd /tmp/dotfiles-uninstall && brew bundle cleanup --force; \
		rm -rf /tmp/dotfiles-uninstall; \
		echo "All Homebrew packages removed"; \
	fi
	@echo ""
	@echo "=================================================="
	@echo "Uninstall complete!"
	@echo ""
	@echo "Note: Homebrew itself was not removed."
	@echo "To completely remove Homebrew, run:"
	@echo "/bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
	@echo "=================================================="
	@# Remove temporary sudoers file
	@if [ -f /etc/sudoers.d/dotfiles_temp ]; then \
		echo "Removing temporary sudo configuration..."; \
		sudo rm -f /etc/sudoers.d/dotfiles_temp; \
	fi

# Create host-specific Brewfile backup
backup-brewfile:
	@echo "Creating Brewfile backup..."
	@hostname=$$(hostname -s); \
	echo "Host: $$hostname"; \
	mkdir -p "brewfiles/$$hostname"; \
	brew bundle dump --file="brewfiles/$$hostname/Brewfile" --force --no-vscode; \
	echo "Brewfile backup created at brewfiles/$$hostname/Brewfile"
