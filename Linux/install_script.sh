#!/bin/bash

        
#                              _     _  
# | _  _|_ _ ||   _ _ _. _ |_   )   / | 
# || )_)|_(_|||  _)(_| ||_)|_  /_ o   |
#                       |

# Set Up

# Options


while getopts as option ; do
    case $option in
    a)
     ;;
    b)
     ;;
    d)
     ;;
    esac
done

InitDir=$(pwd)

## Pacman Set Up

sudo pacman -Syy

## Add Universe repo

sudo chmod 777 /etc/pacman.conf

sudo echo [universe] >> /etc/pacman.conf
sudo echo 'Server = https://universe.artixlinux.org/$arch' >> /etc/pacman.conf
sudo echo 'Server = https://mirror1.artixlinux.org/universe/$arch' >> /etc/pacman.conf
sudo echo 'Server = https://mirror.pascalpuffke.de/artix-universe/$arch' >> /etc/pacman.conf
sudo echo 'Server = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch' >> /etc/pacman.conf
sudo echo 'Server = https://mirror1.cl.netactuate.com/artix/universe/$arch' >> /etc/pacman.conf
sudo echo 'Server = https://ftp.crifo.org/artix-universe/' >> /etc/pacman.conf

sudo chmod 644 /etc/pacman.conf 
sudo pacman -Syy

## Add Arch repos

sudo pacman -S artix-archlinux-support

sudo chmod 777 /etc/pacman.conf

sudo echo [extra] >> /etc/pacman.conf
sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf
sudo echo [multilib] >> /etc/pacman.conf
sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf
sudo echo [community] >> /etc/pacman.conf
sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf
sudo pacman-key --populate archlinux
sudo pacman -Syy

sudo chmod 644 /etc/pacman.conf 

## Yay install

git clone https://aur.archlinux.org/yay-git.git
cd yay-git/
makepkg -si
cd -
sudo rm -R yay-git


yay


## Pipewire

yay -S --noconfirm pipewire pipewire-jack pipewire-pulse wireplumber pipewire-alsa pamixer


## Sway install

yay -S --noconfirm wayland xorg-xwayland wayland-protocols wlroots polkit sway swaybg foot

# Utils

## Regular packages

sudo pacman -S --noconfirm  nautilus code dialog openssh openssh-openrc xdg-user-dirs flatpak jdk-openjdk sddm sddm-openrc librewolf
yay -S --noconfirm ulauncher autotiling waybar wmname waylogout-git connman-gtk udiskie light grim okular nomacs



## Flatpaks

flatpak install com.discordapp.Discord com.simplenote.Simplenote com.github.marktext.marktext  org.gnome.Calculator org.onlyoffice.desktopeditors com.github.tchx84.Flatseal

## AppImages

# wget -P /home/tigo/.local/bin "url"

# Random tasks

## Create ssh keys and activate ssh service
ssh-keygen
sudo rc-update add sshd

## Create user dirs
xdg-user-dirs-update

## Create git_clones folder
Documents=$(xdg-user-dir DOCUMENTS)
cd $Documents
mkdir git_clones
cd git_clones
git clone https://github.com/disco-robot/dotfiles.git


# Config

cd $HOME/.config

## Sway
ln -s $Documents/git_clones/dotfiles/Linux/sway sway
cp $Documents/git_clones/dotfiles/Wallpapers/Tired_nord.png sway
ln -s $Documents/git_clones/dotfiles/Linux/waybar waybar

## Grub
cd $Documents/git_clones/dotfiles/Linux/grub2
chmod +x install.sh
sudo ./install.sh

## Sddm
yay -S --noconfirm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
sudo rc-update add sddm
sudo rm /usr/lib/sddm/sddm.conf.d/default.conf 
sudo cp $Documents/git_clones/dotfiles/Linux/sddm/default.conf /usr/lib/sddm/sddm.conf.d
sudo cp -R $Documents/git_clones/dotfiles/Linux/sddm/sugar-candy /usr/share/sddm/themes
sudo cp $Documents/git_clones/dotfiles/Wallpapers/Tired_nord.png /usr/share/sddm/themes/sugar-candy/Backgrounds


 

## Programs
ln -s $Documents/git_clones/dotfiles/Linux/foot foot
ln -s $Documents/git_clones/dotfiles/Linux/ulauncher ulauncher

## fonts
yay -S --noconfirm ttf-font-awesome ttf-devicons ttf-material-design-icons-git ttf-nerd-fonts-symbols-mono
sway reload

cd $InitDir




## Themes

yay -S --noconfirm  gnome-themes-extra adwaita-qt5

sudo chmod 777 /etc/environment
sudo echo 'export GTK_THEME=Adwaita-dark' >> /etc/environment
sudo echo 'export QT_STYLE_OVERRIDE=Adwaita-Dark' >> /etc/environment
sudo chmod 644 /etc/environment

# Housecleaning

## Clean history file
export HISTFILE="${XDG_STATE_HOME}"/bash/history

## Uninstall unused packages
sudo pacman -Rns --noconfirm xdg-user-dirs
sudo pacman -Rs --noconfirm  $(pacman -Qdtq)

## Junky things that could end up in errors

### VSCode config

sudo chmod 777 /usr/lib/code/product.json
text=$(echo , '"extensionsGallery": { "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items" }')
line=$(cat /usr/lib/code/product.json | wc -l)
line=$(($line))
line=$(echo $line i $text)
sudo sed -i "$line" /usr/lib/code/product.json
sudo chmod 644 /usr/lib/code/product.json


code --install-extension KevinRose.vsc-python-indent
code --install-extension ms-python.python
code --install-extencion esbenp.prettier-vscode
code --install-extencion github.vscode-pull-request-github
code --install-extencion CoenraadS.bracket-pair-colorizer-2
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-vscode.cpptools
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension redhat.java

# Dev Notes and TIL

# To check permitions octal on linux use stat -c "%a" [filename]
# To test small bits of the code use something like this:
#  awk 'NR >=startline && NR <= endline'dotfiles/Linux/install_script.sh > script_part.sh 

