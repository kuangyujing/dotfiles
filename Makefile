# dotfiles Makefile for macOS development environment setup

.PHONY: help setup-homebrew install-packages setup-bash link-bashrc install-fonts setup-vim setup-git setup all

# Default target
help:
	@echo "Available targets:"
	@echo "  setup            - Complete environment setup (homebrew + packages + bash + bashrc + fonts + vim + git)"
	@echo "  setup-homebrew   - Install Homebrew if not present"
	@echo "  install-packages - Install packages from Brewfile"
	@echo "  setup-bash       - Setup Homebrew bash and make it default shell"
	@echo "  link-bashrc      - Create symbolic link from bash/bashrc to ~/.profile"
	@echo "  install-fonts    - Copy fonts to ~/Library/Fonts"
	@echo "  setup-vim        - Setup vim configuration and plug.vim"
	@echo "  setup-git        - Create symbolic link from git/gitconfig to ~/.gitconfig"
	@echo "  help             - Show this help message"

# Complete setup
setup: setup-homebrew install-packages setup-bash link-bashrc install-fonts setup-vim setup-git
	@echo ""
	@echo "=================================================="
	@echo "Environment setup complete!"
	@echo ""
	@echo "The following has been configured:"
	@echo "  - Homebrew installation"
	@echo "  - Package installation from Brewfile"
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

# Install packages from Brewfile
install-packages: setup-homebrew
	@echo "Installing packages from Brewfile..."
	@cd homebrew && brew bundle
	@echo "Packages installed successfully"

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
