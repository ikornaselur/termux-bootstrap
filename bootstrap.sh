#!/bin/sh

apt-get update
apt-get --assume-yes upgrade

pkg up -y
pkg install -y neovim tmux nodejs python zsh git exa file mosh ripgrep hub perl

#########
# Shell #
#########

# Set up oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

rm ~/.zshrc
# Create simple base .zshrc
cat <<EOF >> ~/.zshrc
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi

export ZSH="\$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source \$ZSH/oh-my-zsh.sh

export EDITOR=nvim

# Aliases
alias vim=nvim
alias ls=exa
alias rg="rg -S"
alias rgff="rg --files -g"
alias p=poetry
alias ,,='git rev-parse --git-dir >/dev/null 2>&1 && cd \`git rev-parse --show-toplevel\` || echo "Not in git repo"'
alias git=hub

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
EOF

# Set up powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Fetch the powerlevel10k config
curl -fLo ~/.p10k.zsh https://gist.githubusercontent.com/ikornaselur/9c2859c08bc72f0918d20ca6afccce47/raw

# Set default shell
chsh -s zsh

##########
# Python #
##########

python -m pip install poetry black mypy ipython isort pynvim flake8

##########
# NodeJS #
##########

npm install -g yarn

########
# Tmux #
########

cat <<EOF >> ~/.tmux.conf
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# vim like movement between panes
bind C-h select-pane -L
bind h select-pane -L
bind C-j select-pane -D
bind j select-pane -D
bind C-k select-pane -U
bind k select-pane -U
bind C-l select-pane -R
bind l select-pane -R

# Set default tmux terminal to 256 color
set -g default-terminal "screen-256color"

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin "arcticicestudio/nord-tmux"

# Initialize TMUX plugin manager
run '~/.tmux/plugins/tpm/tpm'
EOF

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

##########
# Termux #
##########
# Clear default motd
rm /data/data/com.termux/files/usr/etc/motd

# Termux properties
cat <<EOF >> ~/.termux/termux.properties
extra-keys = [ \
 ['ESC','|','/','-','UP', 'BKSP', '"'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT', '%'] \
]
EOF

# Font
curl -fLo ~/.termux/font.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf

#######
# FZF #
#######

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

#######
# Vim #
#######

# Clone dotfiles
mkdir projects
git clone https://github.com/ikornaselur/dotfiles projects/dotfiles

# Set up neovim config
mkdir -p .config/nvim
ln -s ~/projects/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
nvim +'PlugInstall --sync' +qall

echo "All done! Restart Termux..."
echo "Don't forget to termux-setup-storage !"
