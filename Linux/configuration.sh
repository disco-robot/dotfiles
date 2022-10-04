#!/bin/bash

# Variables

int_regex='[0-1]'
InitDir=$(pwd)

# Options

while :
do
    printf "\nChoose WM or DE:\n\n0-sway; 1-hyprland\n\n"
    read WM
    if [[ $WM =~ $int_regex ]] ;then
        break
    fi
    printf "\nOption not valid\n\n"
done


# Pacman and Yay Set Up

printf "\n\n\nPacman and Yay Set Up\n\n\n"

sudo pacman -Syy

## Add universe repo
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

## Ass Arch repos
    sudo pacman -S artix-archlinux-support

    sudo chmod 777 /etc/pacman.conf

    sudo echo [extra] >> /etc/pacman.conf
    sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf
    sudo echo [multilib] >> /etc/pacman.conf
    sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf
    sudo echo [community] >> /etc/pacman.conf
    sudo echo Include = /etc/pacman.d/mirrorlist-arch >> /etc/pacman.conf

## Yay install

    git clone https://aur.archlinux.org/yay-git.git
    cd yay-git
    makepkg -si
    yay
    cd -
    sudo rm -R yay-git

## Pipewire

printf "\n\n\nPipewire Set Up\n\n\n"

yay -S --noconfirm pipewire pipewire-jack pipewire-pulse wireplumber pipewire-alsa pamixer playerctl


## WM or DE

case $WM in
  0)
    printf "\n\n\nSWAY install\n\n\n"
    yay -S --noconfirm wayland xorg-xwayland wayland-protocols waybar wlroots polkit sway swaybg foot
    git clone --depth=1 https://github.com/adi1090x/rofi.git
    cd rofi
    chmod +x setup.sh
    ./setup.sh
    cd ../
    rm -R rofi
    ;;

  1)
    printf "\n\n\nHyprland install\n\n\n"
    yay -S --noconfirm wayland xorg-xwayland wayland-protocols wlroots polkit hyprland swaybg foot rofi
    git clone --depth=1 https://github.com/adi1090x/rofi.git
    cd rofi
    chmod +x setup.sh
    ./setup.sh
    cd ../
    rm -R rofi
    ;;
esac

## Regular packages

printf "\n\n\nRegular packages installtion\n\n\n"
sudo pacman -S --noconfirm  nautilus code dialog openssh openssh-openrc xdg-user-dirs flatpak jdk-openjdk sddm sddm-openrc librewolf
yay -S --noconfirm autotiling wmname waylogout-git connman-gtk udiskie light grim eog evince


## Flatpaks

printf "\n\n\nFlatpaks installtion\n\n\n"
flatpak install com.discordapp.Discord com.github.marktext.marktext  org.gnome.Calculator org.onlyoffice.desktopeditors com.github.tchx84.Flatseal org.ferdium.Ferdium

## AppImages

# wget -P /home/tigo/.local/bin "url"

# Random tasks

printf "\n\n\nRandom tasks\n\n\n"


## Create ssh keys and activate ssh service
echo "ssh"
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

## WM or DE

case $WM in
  0)
    ln -s $Documents/git_clones/dotfiles/Linux/sway $HOME/.config/sway
    cp $Documents/git_clones/dotfiles/Wallpapers/Tired_nord.png $HOME/.config/sway/Wallpaper.png
    ln -s $Documents/git_clones/dotfiles/Linux/waybar waybar
    ;;

  1)
    ln -s $Documents/git_clones/dotfiles/Linux/hypr $HOME/.config/hypr
    cp $Documents/git_clones/dotfiles/Wallpapers/Tired_nord.png $HOME/.config/hypr/Wallpaper.png
    ;;
esac

## Grub
cd $Documents/git_clones/dotfiles/Linux/grub2
chmod +x install.sh
sudo ./install.sh

## Sddm
yay -S --noconfirm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
sudo rc-update add sddm
sudo rm /usr/lib/sddm/sddm.conf.d/default.conf 
sudo cp $Documents/git_clones/dotfiles/Linux/sddm/default.conf /usr/lib/sddm/sddm.conf.d
sudo cp -R $Documents/git_clones/dotfiles/Linux/sddm/artix /usr/share/sddm/themes

## Programs
ln -s $Documents/git_clones/dotfiles/Linux/foot $HOME/.config/foot
cp $Documents/git_clones/dotfiles/Linux/lg.sh $HOME/.config/lg.sh

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

# Junky things that could end up in errors

printf "\n\n\nEntering junky territory\n\n\n"

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
