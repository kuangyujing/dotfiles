![dotfiles](.assets/logo.png)

## Get dotfiles

```sh
# (macOS only) Install command line developer tools
if [ $(uname) == "Darwin" ]; then
    xcode-select --install
fi
```

```sh
# Clone repository
git https://github.com/kuangyujing/dotfiles.git
```

## Homebrew

```sh
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
# Backup packages
brew bundle dump

# Restore packages
brew bundle
```

## Basic Setup

```sh
# Set default shell
/usr/bin/chsh -s /opt/homebrew/bin/bash
```

## Install packages

```sh
brew install "python@3.13"
brew install "awscli"
brew install "bash"
brew install "bash-completion"
brew install "bat"
brew install "btop"
brew install "cliclick"
brew install "code-minimap"
brew install "coreutils"
brew install "curl"
brew install "eksctl"
brew install "git"
brew install "glow"
brew install "go"
brew install "go-task"
brew install "golang-migrate"
brew install "helm"
brew install "htop"
brew install "httpie"
brew install "kubecolor"
brew install "kubernetes-cli"
brew install "kubeseal"
brew install "lazydocker"
brew install "make"
brew install "node@22"
brew install "terraform"
brew install "tree"
brew install "watch"
brew install "wget"
brew install "yq"
brew install "daipeihust/tap/im-select"
brew install "xo/xo/usql"
```

## Install Apps

* Iterm2: https://iterm2.com/downloads.html
* AppCleaner: https://freemacsoft.net/appcleaner/
* LinerMouse: https://linearmouse.app/

