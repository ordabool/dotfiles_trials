# Installation Guide

## Prerequisites

None! The bootstrap script will install everything you need.

## Installation Methods

### Method 1: One-liner (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ordabool/dotfiles_trials/main/bootstrap.sh)
```

### Method 2: Clone and Run

```bash
git clone https://github.com/ordabool/dotfiles_trials.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

### Method 3: Manual Installation

If you prefer to do things step by step:

```bash
# 1. Clone the repo
git clone https://github.com/ordabool/dotfiles_trials.git ~/.dotfiles

# 2. Install system dependencies
# Ubuntu/Debian:
sudo apt-get update
sudo apt-get install -y git curl wget tmux zsh fzf ripgrep jq xclip build-essential

# 3. Install Node.js v20+
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 4. Install Neovim (latest)
cd /tmp
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -xzf nvim-linux64.tar.gz -C /opt
sudo mv /opt/nvim-linux64 /opt/nvim-linux-x86_64

# 5. Install Claude Code
sudo npm install -g @anthropic-ai/claude-code

# 6. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 7. Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 8. Install Nerd Font
mkdir -p ~/.local/share/fonts
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.zip
unzip -o DejaVuSansMono.zip -d ~/.local/share/fonts
fc-cache -fv

# 9. Create symlinks
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/nvim ~/.config/nvim

# 10. Set zsh as default shell
chsh -s $(which zsh)
```

## Post-Installation

1. **Restart your terminal** or run: `source ~/.zshrc`

2. **Configure Powerlevel10k** (first time only):
   ```bash
   p10k configure
   ```

3. **Open Neovim** - Lazy.nvim will auto-install plugins:
   ```bash
   nvim
   ```
   Wait for all plugins to install, then restart nvim.

4. **Set up Claude Code**:
   ```bash
   claude
   ```
   Follow the authentication prompts.

5. **Configure your terminal emulator**:
   - Set font to: `DejaVuSansM Nerd Font` (or any Nerd Font)
   - Font size: 11-13pt recommended
   - Enable 256 colors

## Verifying Installation

Check that everything is installed correctly:

```bash
# Check versions
nvim --version
tmux -V
node --version
claude --version
zsh --version

# Check font (should see icons)
echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
```

## Troubleshooting

### Neovim plugins not loading
```bash
# Open nvim and run:
:Lazy sync
```

### Powerlevel10k not showing icons
- Make sure your terminal uses a Nerd Font
- Run `p10k configure` to reconfigure

### Claude Code not found
```bash
# Install manually via npm
sudo npm install -g @anthropic-ai/claude-code
```

### Tmux prefix not working
- Default prefix is `Ctrl+a` (not `Ctrl+b`)
- Test with: `Ctrl+a ?` (shows keybindings)

### Zsh not default shell
```bash
chsh -s $(which zsh)
# Then log out and log back in
```

## Updating

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull
# Restart terminal or source ~/.zshrc
```

To update plugins:

```bash
# Neovim plugins
nvim
:Lazy sync

# Oh My Zsh
omz update

# Powerlevel10k
cd ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git pull
```
