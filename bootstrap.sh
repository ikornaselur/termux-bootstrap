#!/bin/sh

# Update
pkg up -y

# Install packages
pkg install -y neovim tmux nodejs python zsh git exa file mosh ripgrep

#########
# Shell #
#########

# Set up oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

rm ~/.zshrc
# Create simple base .zshrc
cat <<EOF >> ~/.zshrc
export ZSH="/data/data/com.termux/files/home/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source /data/data/com.termux/files/home/.oh-my-zsh/oh-my-zsh.sh

# Aliases
alias vim=nvim
alias ls=exa
alias rg="rg -S"
alias rgff="rg --files -g"
alias p=poetry
alias ,,='git rev-parse --git-dir >/dev/null 2>&1 && cd `git rev-parse --show-toplevel` || echo "Not in git repo"'
EOF

# Set up powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

##########
# Python #
##########

python -m pip install poetry black mypy ipython isort pynvim flake8

##########
# NodeJS #
##########

npm install -g yarn

########
# Misc #
########

# Clear default motd
rm /data/data/com.termux/files/usr/etc/motd

# Set default shell
chsh -s zsh

# Set default tmux terminal to 256 colour
echo "set -g default-terminal \"screen-256color\"" > ~/.tmux.conf

curl -fLo ~/.p10k.zsh https://gist.githubusercontent.com/ikornaselur/9c2859c08bc72f0918d20ca6afccce47/raw/ff6bab27ce3b2c12fd094b19b87ffab2b72e2027/.p10k.zsh

#################
# Termux config #
#################
cat <<EOF >> ~/.termux/termux.properties
extra-keys = [ \
 ['ESC','|','/','-','UP', 'BKSP'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT'] \
]
EOF

# Font
curl -fLo ~/.termux/font.tff https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf

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
