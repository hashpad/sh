cp -rf ~/.X* ~/.asoundrc ~/.bashrc ~/.urxvt ~/.vim ~/.vimrc ~/.xbindkeysrc ~/.xinitrc ~/.dotfiles/
cp -rf ~/.config/fontconfig ~/.dotfiles/.config/
cd ~/.dotfiles
find . -mindepth 2 -type d -name ".git" -exec rm -rf {} +
git add *
git commit -m "$1"
git push -u origin master

