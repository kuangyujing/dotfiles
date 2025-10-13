# CLAUDE.md

This file provides context to Claude Code when working with this macOS dotfiles automation repository.

## QUICK REFERENCE

### What This Repository Does
- **Purpose**: Automated macOS development environment setup via Makefile
- **Strategy**: Copy configuration files (not symlinks) for repository independence
- **Philosophy**: Idempotent operations, single sudo prompt, clean state rebuilding

### Critical User-Facing Commands
```bash
make setup                  # Core: homebrew + packages + shell + configs
make setup-apps             # Apps: macOS applications + system settings
make optional-cloud-cli     # Optional: AWS/Azure CLI
make optional-docker        # Optional: Docker + colima
make optional-kubernetes    # Optional: minikube + kubectl
make backup-brewfile        # Backup current Brewfile to brewfiles/[hostname]/
make uninstall             # Complete removal + restore defaults
```

## ARCHITECTURE ESSENTIALS

### Target Structure
- **Public targets**: `setup`, `setup-apps`, `optional-*`, `uninstall`, `backup-brewfile`
- **Internal targets**: `_*` prefix (called by public targets, not user-facing)
- **Authentication**: `_authenticate` required for shell/system modifications, NOT for Homebrew operations

### Installed Packages (23 packages in _install-packages)
**Core Tools**: bash, bash-completion, git, gh, make
**Languages**: go, node@22
**CLI Utilities**: bat, tree, jq, yq, curl, wget, watch
**GNU Tools**: coreutils, findutils, diffutils, binutils
**Specialized**: glow, cliclick, code-minimap, im-select (from daipeihust/tap)

### Installed Applications
**Development Apps** (_install-dev-apps): GitHub Desktop
**macOS Apps** (_install-apps): iTerm2, Alt-Tab, Displaperture, LinearMouse, Stats, VS Code

### Configuration File Mappings
```
bash/bashrc → ~/.profile
vim/vimrc → ~/.vimrc
vim/plug.vim → ~/.vim/autoload/plug.vim
git/gitconfig → ~/.gitconfig
linearmouse/linearmouse.json → ~/.config/linearmouse/
alt-tab/com.lwouis.alt-tab-macos.plist → ~/Library/Preferences/
fonts/*.ttf → ~/Library/Fonts/
/etc/sudoers.d/dotfiles_temp → Temporary sudo timeout (auto-cleaned on uninstall)
```

## MODIFICATION RULES FOR CLAUDE CODE

### Core Architectural Constraints (NEVER VIOLATE)
1. **File copying only**: Never use symbolic links (breaks repository independence)
2. **Single authentication**: One `sudo -v` prompt per session via `_authenticate`
3. **Idempotency**: All targets must be safe to run multiple times
4. **Target naming**: Public (`setup*`, `optional-*`), Internal (`_*`)
5. **Cleanup requirement**: Every installed item MUST have uninstall logic

### Authentication Decision Tree
```
Requires _authenticate:
  ✓ Modifying /etc/shells, running chsh
  ✓ Writing to /etc/sudoers.d/
  ✓ System-wide preferences (defaults write -g)
  ✓ Service management (colima, minikube)

Does NOT require _authenticate:
  ✓ Homebrew operations (brew install, brew bundle)
  ✓ Home directory operations (~/.config, ~/.vimrc)
  ✓ Copying files to ~/Library/
```

### Adding New Configuration (Standard Pattern)
**Reference implementations in Makefile**:
- `_configure-bash`: Removes old shell configs, copies bash/bashrc → ~/.profile
- `_configure-vim`: Creates ~/.vim/autoload/, copies vimrc and plug.vim
- `_configure-git`: Copies git/gitconfig → ~/.gitconfig
- `_configure-linearmouse`: Creates ~/.config/linearmouse/, copies config
- `_configure-alt-tab`: Copies plist → ~/Library/Preferences/

**Checklist**:
1. Create config directory: `mkdir app/` with config files
2. Add internal target: `_configure-app:` with dependencies
3. Remove existing files first: `rm -f ~/.apprc` or `rm -rf ~/.app/`
4. Copy from repository: `cp app/config ~/.apprc`
5. Add to appropriate public target: `setup` or `setup-apps`
6. Update `.PHONY` declaration at top of Makefile
7. Add cleanup to `uninstall` target

### Adding Packages
**To `_install-packages`**: Core CLI tools for all users (bash, git, go, node@22, CLI utilities, GNU tools)
**To `_install-dev-apps`**: Desktop development applications (GitHub Desktop)
**To `_install-apps`**: General macOS applications (iTerm2, Alt-Tab, LinearMouse, Stats, VS Code, etc)
**To `optional-*` targets**: Optional development environments (see below)

**Never mix categories** - each serves distinct purpose and installation timing.

### Adding Optional Environment
**Reference implementations**: `optional-docker` and `optional-kubernetes` in Makefile

**Pattern**:
1. Create target: `optional-name: _authenticate _install-homebrew`
2. Install packages: `brew install package1 package2`
3. Start services: Check status first with `if ! status; then start; fi`
4. Verify: Test functionality, output `✓` success or `⚠` warning with troubleshooting
5. Show usage: Echo example commands for user

**Example verification pattern from `optional-docker`**:
- Check colima status, start if needed
- Verify docker connectivity with `docker info`
- Check docker context, switch to colima if needed
- Echo usage examples

### Uninstall Completeness
**Critical**: Every modification MUST be reverted in `uninstall` target.

**Required cleanup operations** (see `uninstall` target in Makefile):
- Config files → Loop through and remove from home directory
- Vim directory → `rm -rf ~/.vim`
- App configs → Remove from ~/.config/ and ~/Library/Preferences/
- Installed fonts → Remove from ~/Library/Fonts/
- System changes → Restore shell to /bin/bash, remove from /etc/shells
- Packages → Use empty Brewfile technique (create temp Brewfile, run `brew bundle cleanup --force`)
- **MUST remove**: `/etc/sudoers.d/dotfiles_temp` (critical security cleanup)

## COMMON PATTERNS & BEST PRACTICES

### Target Execution Patterns
- Always echo operation start: `@echo "Configuring app..."`
- Always echo operation completion: `@echo "App configured successfully"`
- Use `@` prefix to suppress command echo (cleaner output)
- Check existence before removal: `if [ -e file ]; then rm -f file; fi`
- Service verification: Check status, start if needed, verify connectivity

### Error Handling (for optional-* targets)
```bash
@if service_check >/dev/null 2>&1; then
    echo "✓ Service operational"
else
    echo "⚠ Service not responding"
    echo "Try: manual_command"
fi
```

### Testing Your Changes
1. **Idempotency**: Run target 2-3 times, verify no errors
2. **Cleanup**: Run `make uninstall`, check nothing remains
3. **Authentication**: Verify single password prompt for entire session
4. **Sudo cleanup**: Check `/etc/sudoers.d/dotfiles_temp` removed after uninstall

## DIRECTORY STRUCTURE OVERVIEW

```
dotfiles/
├── Makefile                 # Main automation (all targets)
├── README                   # Man page format documentation
├── CLAUDE.md               # This file (Claude Code context)
├── defaults-management.md  # Future feature design (NOT IMPLEMENTED)
├── bash/bashrc             # Bash configuration → ~/.profile
├── vim/vimrc               # Vim configuration → ~/.vimrc
├── vim/plug.vim            # Vim plugin manager → ~/.vim/autoload/
├── git/gitconfig           # Git configuration → ~/.gitconfig
├── fonts/*.ttf             # UDEVGothic fonts → ~/Library/Fonts/
├── linearmouse/            # LinearMouse config → ~/.config/linearmouse/
├── alt-tab/                # Alt-Tab config → ~/Library/Preferences/
├── vscode/                 # VS Code settings (reference only, not automated)
├── iterm/                  # iTerm2 settings (reference only, not automated)
├── brewfiles/[hostname]/   # Host-specific Brewfile backups
├── apt/                    # Ubuntu apt config (legacy, not used on macOS)
├── ubuntu/                 # Ubuntu-specific bashrc (legacy, not used)
├── chrome/                 # Chrome extensions list (reference only)
├── git-prompt/             # Git prompt script (sourced by bashrc)
└── tmux/                   # tmux config (reference only, not automated)
```

**Note**: Only files explicitly copied in Makefile targets are automated. Other files are for reference or future implementation.

## IMPLEMENTATION CHECKLIST

When modifying this repository:
- [ ] Follow target naming (`_internal`, `public`, `optional-*`)
- [ ] Add `_authenticate` dependency ONLY if needed (see decision tree)
- [ ] Implement cleanup in `uninstall` target
- [ ] Update `.PHONY` declaration at top of Makefile
- [ ] Test idempotency (safe to run 2-3 times)
- [ ] Verify single password prompt works
- [ ] Confirm complete cleanup after uninstall
- [ ] Read Makefile for current implementation patterns before coding