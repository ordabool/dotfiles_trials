#!/usr/bin/env bash

set -e  # Exit on error

# Determine if we need sudo
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        else
            log_error "Cannot detect Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install packages based on OS
install_packages() {
    log_info "Installing system packages..."

    case $OS in
        ubuntu|debian|pop)
            local packages="git curl wget unzip tmux zsh fzf ripgrep jq bc xclip build-essential fontconfig sysstat"
            $SUDO apt-get update
            $SUDO apt-get install -y $packages
            # Install GitHub CLI
            if ! command_exists gh; then
                log_info "Installing GitHub CLI..."
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                $SUDO chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | $SUDO tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                $SUDO apt-get update
                $SUDO apt-get install -y gh
            fi
            ;;
        fedora|rhel|centos)
            local packages="git curl wget unzip tmux zsh fzf ripgrep jq bc xclip fontconfig sysstat"
            $SUDO dnf install -y $packages gh
            ;;
        arch|manjaro)
            local packages="git curl wget unzip tmux zsh fzf ripgrep jq bc xclip base-devel fontconfig sysstat"
            $SUDO pacman -Sy --noconfirm $packages github-cli
            ;;
        macos)
            if ! command_exists brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            local packages="git curl wget unzip tmux zsh fzf ripgrep jq bc fontconfig"
            brew install $packages gh
            ;;
        *)
            log_error "Unsupported OS for automatic package installation: $OS"
            exit 1
            ;;
    esac

    log_success "System packages installed"
}

# Install Node.js (v20+)
install_nodejs() {
    if command_exists node; then
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 20 ]; then
            log_success "Node.js v$NODE_VERSION already installed (>= v20)"
            return
        fi
    fi

    log_info "Installing Node.js v20..."

    case $OS in
        ubuntu|debian|pop)
            if [ -z "$SUDO" ]; then
                curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            else
                curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO -E bash -
            fi
            $SUDO apt-get install -y nodejs
            ;;
        fedora|rhel|centos)
            if [ -z "$SUDO" ]; then
                curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
            else
                curl -fsSL https://rpm.nodesource.com/setup_20.x | $SUDO bash -
            fi
            $SUDO dnf install -y nodejs
            ;;
        arch|manjaro)
            $SUDO pacman -S --noconfirm nodejs npm
            ;;
        macos)
            brew install node@20
            ;;
    esac

    log_success "Node.js installed: $(node --version)"
}

# Install Neovim (latest version from binary)
install_neovim() {
    if [ -f /opt/nvim-linux-x86_64/bin/nvim ]; then
        log_success "Neovim already installed at /opt/nvim-linux-x86_64/bin/nvim"
        return
    fi

    log_info "Installing Neovim (latest stable)..."

    if [[ "$OS" == "macos" ]]; then
        brew install neovim
    else
        # Download latest Neovim binary
        cd /tmp
        wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
        $SUDO tar -xzf nvim-linux-x86_64.tar.gz -C /opt
        rm nvim-linux-x86_64.tar.gz
    fi

    log_success "Neovim installed: $(/opt/nvim-linux-x86_64/bin/nvim --version | head -n1)"
}

# Install luarocks
install_luarocks() {
    if command_exists luarocks; then
        log_success "luarocks already installed"
        return
    fi

    log_info "Installing luarocks..."

    case $OS in
        ubuntu|debian|pop)
$SUDO apt-get install -y luarocks
            ;;
        fedora|rhel|centos)
$SUDO dnf install -y luarocks
            ;;
        arch|manjaro)
$SUDO pacman -S --noconfirm luarocks
            ;;
        macos)
            brew install luarocks
            ;;
    esac

    log_success "luarocks installed"
}

# Install Claude Code
install_claude_code() {
    if command_exists claude; then
        log_success "Claude Code already installed"
        return
    fi

    log_info "Installing Claude Code..."

    # Use official installer script
    if curl -fsSL https://claude.ai/install.sh | bash; then
        # Update PATH for current session so subsequent commands can find claude
        export PATH="$HOME/.local/bin:$PATH"
        log_success "Claude Code installed"
    else
        log_error "Failed to install Claude Code"
        return 1
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_success "Oh My Zsh already installed"
        return
    fi

    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_success "Oh My Zsh installed"
}

# Install Powerlevel10k
install_powerlevel10k() {
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ -d "$P10K_DIR" ]; then
        log_success "Powerlevel10k already installed"
        return
    fi

    log_info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"

    log_success "Powerlevel10k installed"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    local TPM_DIR="$HOME/.tmux/plugins/tpm"

    if [ -d "$TPM_DIR" ]; then
        log_success "TPM already installed"
    else
        log_info "Installing TPM (Tmux Plugin Manager)..."
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
        log_success "TPM installed"
    fi

    # Install tmux plugins automatically (only if tmux is running)
    if [ -n "$TMUX" ] && [ -f "$TPM_DIR/bin/install_plugins" ]; then
        log_info "Installing tmux plugins..."
        "$TPM_DIR/bin/install_plugins"
        log_success "Tmux plugins installed"
    fi
}

# Install Nerd Font
install_nerd_font() {
    log_info "Checking for Nerd Fonts..."

    if [[ "$OS" == "macos" ]]; then
        brew tap homebrew/cask-fonts
        brew install --cask font-dejavu-sans-mono-nerd-font
        log_success "DejaVuSansM Nerd Font installed via Homebrew"
    else
        local FONT_DIR="$HOME/.local/share/fonts"
        local FONT_FILE="$FONT_DIR/DejaVuSansMNerdFont-Regular.ttf"

        if [ -f "$FONT_FILE" ]; then
            log_success "Nerd Font already installed"
            return
        fi

        log_info "Installing DejaVuSansM Nerd Font..."
        mkdir -p "$FONT_DIR"
        cd /tmp

        if ! wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.zip; then
            log_error "Failed to download Nerd Font"
            return 1
        fi

        if ! unzip -q -o DejaVuSansMono.zip -d "$FONT_DIR"; then
            log_error "Failed to extract Nerd Font"
            rm -f DejaVuSansMono.zip
            return 1
        fi

        rm DejaVuSansMono.zip

        if command_exists fc-cache; then
            fc-cache -fv
            log_success "Nerd Font installed and cache updated"
        else
            log_success "Nerd Font installed (fc-cache not available, restart terminal to apply)"
        fi

        log_warning "Set your terminal to use 'DejaVuSansM Nerd Font' for best experience"
    fi
}

# Install Noto Sans Symbols 2 font (for Tokyo Night tmux)
install_noto_symbols() {
    log_info "Checking for Noto Sans Symbols 2 font..."

    if [[ "$OS" == "macos" ]]; then
        brew install --cask font-noto-sans-symbols-2
        log_success "Noto Sans Symbols 2 installed via Homebrew"
    else
        local FONT_DIR="$HOME/.local/share/fonts"
        local FONT_FILE="$FONT_DIR/NotoSansSymbols2-Regular.ttf"

        if [ -f "$FONT_FILE" ]; then
            log_success "Noto Sans Symbols 2 already installed"
            return
        fi

        log_info "Installing Noto Sans Symbols 2 font..."
        mkdir -p "$FONT_DIR"
        cd "$FONT_DIR"

        if ! wget -q https://github.com/google/fonts/raw/main/ofl/notosanssymbols2/NotoSansSymbols2-Regular.ttf; then
            log_error "Failed to download Noto Sans Symbols 2"
            return 1
        fi

        if command_exists fc-cache; then
            fc-cache -fv
            log_success "Noto Sans Symbols 2 installed and cache updated"
        else
            log_success "Noto Sans Symbols 2 installed (fc-cache not available, restart terminal to apply)"
        fi
    fi
}

# Clone dotfiles repo
clone_dotfiles() {
    if [ -d "$HOME/.dotfiles/.git" ]; then
        log_success "Dotfiles repo already exists"
        return
    fi

    log_info "Cloning dotfiles repository..."

    if [ -d "$HOME/.dotfiles" ]; then
        log_warning "~/.dotfiles exists but is not a git repo. Backing up to ~/.dotfiles.backup"
        mv "$HOME/.dotfiles" "$HOME/.dotfiles.backup"
    fi

    # Replace with your actual GitHub repo URL
    git clone https://github.com/ordabool/dotfiles_trials.git "$HOME/.dotfiles"

    log_success "Dotfiles cloned"
}

# Create symlinks
create_symlinks() {
    log_info "Creating symlinks..."

    local dotfiles=(
        ".zshrc"
        ".bashrc"
        ".tmux.conf"
        ".p10k.zsh"
    )

    for dotfile in "${dotfiles[@]}"; do
        local source="$HOME/.dotfiles/$dotfile"
        local target="$HOME/$dotfile"

        if [ -L "$target" ]; then
            log_success "Symlink already exists: $dotfile"
            continue
        fi

        if [ -f "$target" ]; then
            log_warning "Backing up existing $dotfile to ${dotfile}.backup"
            mv "$target" "${target}.backup"
        fi

        ln -s "$source" "$target"
        log_success "Created symlink: $dotfile"
    done

    # Symlink nvim config
    local nvim_source="$HOME/.dotfiles/nvim"
    local nvim_target="$HOME/.config/nvim"

    if [ -L "$nvim_target" ]; then
        log_success "Neovim config symlink already exists"
    else
        mkdir -p "$HOME/.config"
        if [ -d "$nvim_target" ]; then
            log_warning "Backing up existing nvim config to ~/.config/nvim.backup"
            mv "$nvim_target" "$nvim_target.backup"
        fi
        ln -s "$nvim_source" "$nvim_target"
        log_success "Created symlink: nvim config"
    fi
}

# Set zsh as default shell
set_default_shell() {
    if [ "$SHELL" = "$(which zsh)" ]; then
        log_success "Zsh is already the default shell"
        return
    fi

    log_info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"

    log_success "Default shell changed to zsh (restart terminal to apply)"
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     Development Environment Bootstrap Script         ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    log_info "Starting bootstrap process..."
    echo

    detect_os
    install_packages
    install_nodejs
    install_neovim
    install_luarocks
    install_claude_code
    install_oh_my_zsh
    install_powerlevel10k
    install_tpm
    install_nerd_font
    install_noto_symbols

    # Only clone if not running from within .dotfiles directory
    if [ "$(pwd)" != "$HOME/.dotfiles" ]; then
        clone_dotfiles
    fi

    create_symlinks
    set_default_shell

    echo
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║            ✓ Bootstrap Complete!                     ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Configure Powerlevel10k: p10k configure"
    echo "  3. Start tmux to see the Tokyo Night theme: tmux"
    echo "  4. Open neovim - plugins will auto-install: nvim"
    echo "  5. Set up Claude Code: claude"
    echo "  6. Make sure your terminal uses 'DejaVuSansM Nerd Font'"
    echo "  7. (Optional) Create ~/.zshrc.local for machine-specific aliases/config"
    echo
    log_warning "If you want to use zsh immediately, run: zsh"
}

# Run main function
main "$@"
