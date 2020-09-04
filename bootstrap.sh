#!/bin/sh

# Update
pkg up -y

# Install packages
pkg install -y neovim tmux nodejs python zsh git exa file mosh neofetch

#########
# Shell #
#########

# Set up oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

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

# Add aliases
echo "alias vim=nvim" >> .zshrc
echo "alias ls=exa" >> .zshrc
echo "neofetch" >> .zshrc

# Clear default motd
rm /data/data/com.termux/files/usr/etc/motd

# Set default shell
chsh -s zsh

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
nvim +PlugInstall +qall

echo "All done! Restart Termill..."
