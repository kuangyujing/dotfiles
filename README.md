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
brew "python@3.13"
brew "awscli"
brew "bash"
brew "bash-completion"
brew "bat"
brew "btop"
brew "cliclick"
brew "code-minimap"
brew "coreutils"
brew "curl"
brew "eksctl"
brew "git"
brew "glow"
brew "go"
brew "go-task"
brew "golang-migrate"
brew "helm"
brew "htop"
brew "httpie"
brew "kubecolor"
brew "kubernetes-cli"
brew "kubeseal"
brew "lazydocker"
brew "make"
brew "node@22"
brew "terraform"
brew "tree"
brew "watch"
brew "wget"
brew "yq"
brew "daipeihust/tap/im-select"
brew "xo/xo/usql"
```

