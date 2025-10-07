![dotfiles](.assets/logo.png)
# dotfiles

Personal dotfiles repository for macOS development environment setup with automated installation using Makefile.

## Quick Setup

### Prerequisites

Install command line developer tools (macOS only):

```bash
xcode-select --install
```

### Clone Repository

```bash
git clone https://github.com/kuangyujing/dotfiles.git
cd dotfiles
```

### Automated Setup

Run the complete setup with a single command:

```bash
make setup
```

This will automatically:
- Install Homebrew (if not present)
- Install all packages from Brewfile (56+ development tools and utilities)
- Setup Homebrew Bash as default shell
- Configure shell environment (bashrc)
- Install fonts (UDEVGothicLG family)
- Setup Vim configuration with vim-plug
- Configure Git settings

## Individual Setup Commands

You can also run individual setup steps:

```bash
make setup-homebrew   # Install Homebrew only
make install-packages # Install packages from Brewfile
make setup-bash       # Setup Homebrew Bash as default shell
make link-bashrc      # Create bashrc symbolic link
make install-fonts    # Copy fonts to ~/Library/Fonts
make setup-vim        # Setup Vim configuration and plugins
make setup-git        # Setup Git configuration
```

## Files Created

### Symbolic Links
The setup creates the following symbolic links to your dotfiles:

- `~/.profile` → `bash/bashrc` (shell configuration)
- `~/.vimrc` → `vim/vimrc` (Vim configuration)  
- `~/.gitconfig` → `git/gitconfig` (Git configuration)
- `~/.vim/autoload/plug.vim` → `vim/plug.vim` (vim-plug manager)

### Directories Created
- `~/.vim/autoload/` (Vim plugin autoload directory)
- `~/Library/Fonts/` (if not exists)

### Files Copied
Fonts are copied (not linked) to `~/Library/Fonts/`:
- `UDEVGothicLG-Bold.ttf`
- `UDEVGothicLG-BoldItalic.ttf`
- `UDEVGothicLG-Italic.ttf`
- `UDEVGothicLG-Regular.ttf`

### System Changes
- Adds `/opt/homebrew/bin/bash` to `/etc/shells`
- Changes user's default shell to Homebrew Bash
- Installs vim plugins via vim-plug (creates `~/.vim/plugged/`)

## Package Management

The repository includes a comprehensive Brewfile with 56+ packages including:

### Development Tools
- Python 3.13, Go, Node.js 22
- Azure CLI, AWS CLI
- Terraform, Helm, kubectl

### CLI Utilities  
- ripgrep, bat, tree, htop, btop
- glow, httpie, curl, wget

### Specialized Tools
- kubecolor, lazydocker, kubeseal
- atlas, eksctl, golang-migrate

### GUI Applications
- GitHub Desktop, QLMarkdown, Stats

### VS Code Extensions
VS Code extensions are **not included** in the Brewfile. This repository uses VS Code's built-in Settings Sync functionality to manage extensions separately. The Brewfile was created with `--no-vscode` option to exclude VS Code extensions from package management.

## Updating Packages

To add new packages and update the Brewfile:

```bash
# Install a new package
brew install <package-name>

# Update Brewfile to reflect current packages (excluding VS Code extensions)
cd homebrew && brew bundle dump --force --no-vscode
```

To restore packages on a new machine:

```bash
# Install all packages from Brewfile
cd homebrew && brew bundle
```

## Uninstallation

To completely remove all configurations and restore defaults:

```bash
make uninstall
```

This will:
- Remove all symbolic links
- Delete Vim configuration and plugins
- Remove installed fonts
- Uninstall Homebrew packages from Brewfile
- Restore default shell to `/bin/bash`
- Remove Homebrew Bash from `/etc/shells`

Note: Homebrew itself is not removed. To completely remove Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Manual Installation (Legacy)

For reference, the following apps may need manual installation:
- [iTerm2](https://iterm2.com/downloads.html)
- [AppCleaner](https://freemacsoft.net/appcleaner/)
- [LinearMouse](https://linearmouse.app/)

## Getting Help

```bash
make help  # Show all available commands
```

## Repository Structure

```
├── Makefile           # Automated setup scripts
├── bash/              # Shell configuration
│   └── bashrc         # Main shell configuration
├── fonts/             # Font files
├── git/               # Git configuration
│   └── gitconfig      # Git settings
├── homebrew/          # Package management
│   └── Brewfile       # Homebrew package definitions
├── vim/               # Vim configuration
│   ├── vimrc          # Vim settings
│   └── plug.vim       # vim-plug plugin manager
└── vscode/            # VS Code configuration
```

After setup, you can close Terminal.app safely. The next time you open a terminal, your new development environment will be active with all configurations applied.

