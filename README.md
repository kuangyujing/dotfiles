![dotfiles](.assets/logo.png)
# dotfiles

Personal dotfiles repository for macOS development environment setup with automated installation using Makefile.

## Quick Setup

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

## Package Management

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

