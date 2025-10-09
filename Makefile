# dotfiles Makefile for macOS development environment setup

.PHONY: help setup-homebrew install-packages install-dev-cli install-dev-apps setup-bash link-bashrc install-fonts setup-vim setup-git install-apps setup-linearmouse setup uninstall all

# Default target
help:
	@echo "Available targets:"
	@echo "  setup            - Complete environment setup (homebrew + packages + dev-cli + dev-apps + bash + bashrc + fonts + vim + git + apps + linearmouse)"
	@echo "  setup-homebrew   - Install Homebrew if not present"
	@echo "  install-packages - Install basic development packages"
	@echo "  install-dev-cli  - Install development CLI tools (kubectl, AWS CLI, Azure CLI, etc.)"
	@echo "  install-dev-apps - Install development desktop applications (Docker Desktop, GitHub Desktop)"
	@echo "  setup-bash       - Setup Homebrew bash and make it default shell"
	@echo "  link-bashrc      - Create symbolic link from bash/bashrc to ~/.profile"
	@echo "  install-fonts    - Copy fonts to ~/Library/Fonts"
	@echo "  setup-vim        - Setup vim configuration and plug.vim"
	@echo "  setup-git        - Create symbolic link from git/gitconfig to ~/.gitconfig"
	@echo "  install-apps     - Install macOS applications"
	@echo "  setup-linearmouse - Setup LinearMouse configuration"
	@echo "  uninstall        - Remove all configurations, packages, and restore defaults"
	@echo "  help             - Show this help message"

# Complete setup
setup: setup-homebrew install-packages install-dev-cli install-dev-apps setup-bash link-bashrc install-fonts setup-vim setup-git install-apps setup-linearmouse
	@echo ""
	@echo "=================================================="
	@echo "Environment setup complete!"
	@echo ""
	@echo "The following has been configured:"
	@echo "  - Homebrew installation"
	@echo "  - Basic development packages"
	@echo "  - Development CLI tools"
	@echo "  - Development desktop applications"
	@echo "  - Homebrew Bash as default shell"
	@echo "  - Bash configuration (bashrc -> ~/.profile)"
	@echo "  - Font installation to ~/Library/Fonts"
	@echo "  - Vim configuration and plugins"
	@echo "  - Git configuration"
	@echo "  - macOS applications"
	@echo "  - LinearMouse configuration"
	@echo ""
	@echo "You can now close Terminal.app safely."
	@echo "Next time you open a terminal, the new environment"
	@echo "will be active with all configurations applied."
	@echo "=================================================="

# Install Homebrew if not already installed
setup-homebrew:
	@echo "Setting up Homebrew..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Homebrew is already installed"; \
	else \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "Homebrew installed successfully"; \
	fi

# Install packages using brew install commands
install-packages: setup-homebrew
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
install-dev-cli: setup-homebrew
	@echo "Installing development CLI tools..."
	@# Kubernetes tools
	@brew install kubectl kubecolor
	@# Cloud CLI tools
	@brew install awscli azure-cli
	@# Container tools
	@brew install docker
	@echo "Development CLI tools installed successfully"

# Install development desktop applications
install-dev-apps: setup-homebrew
	@echo "Installing development desktop applications..."
	@# Development applications
	@brew install --cask docker
	@brew install --cask github
	@echo "Development desktop applications installed successfully"

# Setup Homebrew bash as default shell
setup-bash: install-packages
	@echo "Setting up Homebrew bash..."
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

# Create symbolic link for bashrc
link-bashrc:
	@echo "Setting up bashrc configuration..."
	@# Remove existing shell configuration files
	@for file in ~/.profile ~/.bashrc ~/.bash_profile ~/.bash_logout ~/.zshrc ~/.zprofile; do \
		if [ -e "$$file" ]; then \
			echo "Removing existing $$file"; \
			rm -f "$$file"; \
		fi; \
	done
	@# Create symbolic link
	@ln -s "$$(pwd)/bash/bashrc" ~/.profile
	@echo "Symbolic link created: ~/.profile -> $$(pwd)/bash/bashrc"

# Install fonts
install-fonts:
	@echo "Installing fonts..."
	@mkdir -p ~/Library/Fonts
	@cp fonts/*.ttf ~/Library/Fonts/
	@echo "Fonts copied to ~/Library/Fonts"

# Setup vim configuration
setup-vim:
	@echo "Setting up vim configuration..."
	@# Remove existing vim configuration files
	@for file in ~/.vimrc ~/.vim; do \
		if [ -e "$$file" ]; then \
			echo "Removing existing $$file"; \
			rm -rf "$$file"; \
		fi; \
	done
	@# Create ~/.vim/autoload directory
	@mkdir -p ~/.vim/autoload
	@# Create symbolic links
	@ln -s "$$(pwd)/vim/vimrc" ~/.vimrc
	@ln -s "$$(pwd)/vim/plug.vim" ~/.vim/autoload/plug.vim
	@echo "Symbolic links created:"
	@echo "  ~/.vimrc -> $$(pwd)/vim/vimrc"
	@echo "  ~/.vim/autoload/plug.vim -> $$(pwd)/vim/plug.vim"
	@# Install vim plugins using vim-plug
	@echo "Installing vim plugins..."
	@vim +PlugInstall +qall

# Setup git configuration
setup-git:
	@echo "Setting up git configuration..."
	@# Remove existing git configuration
	@if [ -e ~/.gitconfig ]; then \
		echo "Removing existing ~/.gitconfig"; \
		rm -f ~/.gitconfig; \
	fi
	@# Create symbolic link
	@ln -s "$$(pwd)/git/gitconfig" ~/.gitconfig
	@echo "Symbolic link created: ~/.gitconfig -> $$(pwd)/git/gitconfig"

# Install macOS applications
install-apps:
	@echo "Installing macOS applications..."
	@brew install --cask iterm2
	@brew install --cask alt-tab
	@brew install --cask displaperture
	@brew install --cask linearmouse
	@brew install --cask stats
	@echo "macOS applications installed successfully"

# Setup LinearMouse configuration
setup-linearmouse:
	@echo "Setting up LinearMouse configuration..."
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
