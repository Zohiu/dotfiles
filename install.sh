#!/bin/bash

# CHANGE THESE
EMAIL="mail@zohiu.de"
USERNAME="Zohiu"

# Colors
NO_FORMAT="\033[0m"
RESET="\033[38;5;8m"
INFO="\033[38;5;87m"
SUCCESS="\033[38;5;154m"
ERROR="\033[38;5;9m"
TITLE="\033[38;5;213m"

echo -e "${TITLE}Welcome to Zohiu's arch install/update script!${RESET}"
echo -e "${INFO}If you aren't me, make sure to change the variables at the top of the script.${RESET}"
if [ "$EUID" == "0" ]
    then echo -e "${ERROR}Do not run this script as root!${RESET}"; exit
fi


USER=$(whoami)

packages_system="linux-headers fish man-db expac reflector find-the-command fzf eza bat hwinfo gvfs networkmanager v4l2loopback-dkms v4l-utils v4l2loopback-utils slurp"
packages_gpu="xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau"
packages_audio="pipewire pavucontrol wireplumber pipewire-alsa pipewire-jack pipewire-pulse pipewire-audio ffmpeg pamixer alsa-utils"
packages_user="python-pip git neofetch neovim btop micro wine ffmpeg ffmpegthumbs ffmpegthumbnailer xclip pipewire-v4l2 flatpak radeontop"

packages_desktop="qt6-wayland qt5-wayland xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome gnome-keyring swayfx wofi swaylock-effects grimshot mako nwg-launchers clipman wl-color-picker libnotify kservice wlrobs-hg brightnessctl light"
packages_theme="lxappearance kvantum qt6ct ttf-font-awesome nerd-fonts noto-fonts-emoji"

packages_apps="visual-studio-code-bin qpwgraph gwenview ark mpv gedit nemo thunar dolphin vivaldi armcord modrinth-app spotify steam bitwig-studio nextcloud-client obs-studio"


function run_install()
{
    # Installation can take long on a slow internet connection.
    # I want to enter the password once and then have it run without asking again
    echo -ne "${NO_FORMAT}Please enter your sudo password: ${RSET}"
    read -s password
    echo
    
    # Make sudo use password from variable
    alias sudo="echo $password | sudo -s"
    

    # Install paru if it doesn't exist yet
    if ! command -v paru --version &> /dev/null
    then
        echo -e "${ERROR}paru not found! Installing...${RESET}"
        echo -e "${INFO}Installing paru...${RESET}"
        sudo pacman -S --noconfirm --needed base-devel git
        git clone https://aur.archlinux.org/paru.git
        cd paru && makepkg -si
        cd . && rm -rd paru
        echo -e "${SUCCESS}paru installed!${RESET}"
    else
        echo -e "${SUCCESS}paru found!${RESET}"
    fi

    # Installation
    echo -e "${INFO}Installing packages...${RESET}"
    echo $password | sudo -s paru -Syu --noconfirm --needed $packages_system $packages_gpu $packages_audio $packages_user $packages_desktop $packages_theme $packages_apps
    echo -e "${SUCCESS}Packages installed!${RESET}"

    # Setup git globals
    echo -e "${INFO}Setting git globals...${RESET}"
    git config --global init.defaultBranch main
    git config --global user.email $EMAIL
    git config --global user.name $USERNAME
    echo -e "${SUCCESS}git globals set up!${RESET}"

    # Setup fish shell
    echo -e "${INFO}Setting up fish shell...${RESET}"
    echo $password | sudo -s chsh -s /usr/bin/fish $USER
    if ! fish -c "type omf > /dev/null"; then
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
        fish -c "omf install https://github.com/catppuccin/fish"
    fi

    yes | fish -c 'fish_config theme save "Catppuccin Mocha"'
    echo -e "${SUCCESS}fish set up!${RESET}"

    # GTK themes
    echo -e "${INFO}Copying GTK themes...${RESET}"
    echo $password | sudo -s cp -rd gtk-themes/. /usr/share/themes/
    echo -e "${SUCCESS}GTK themes copied!${RESET}"

    # Fix dolphin MIME
    echo -e "${INFO}Setting up plasma-applications.menu for Dolphin...${RESET}"
    echo $password | sudo -s ln -sf /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu
    kbuildsycoca6
    echo -e "${SUCCESS}plasma-applications.menu created!${RESET}"

    # Setup autologin on tty1
    echo -e "${INFO}Enabling autologin on tty1...${RESET}"
    echo $password | sudo -s systemctl set-default multi-user.target
    echo $password | sudo -s systemctl enable getty@tty1
    echo $password | sudo -s mkdir -p /etc/systemd/system/getty@tty1.service.d
    echo "[Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM" | \
    echo $password | sudo -s tee /etc/systemd/system/getty@tty1.service.d/autologin.conf > /dev/null
    echo -e "${SUCCESS}Autologin enabled!${RESET}"

    # Disable account lock on incorrect password
    echo -e "${INFO}Disabling account locking on incorrect password attempts..."
    echo "deny = 0" | echo $password | sudo -s tee gedit /etc/security/faillock.conf > /dev/null
    echo -e "${SUCCESS}Faillock disabled!${RESET}"

    # Move the actual config stuff
    echo -e "${INFO}Copying config files...${RESET}"
    source update-config.sh
    echo -e "${SUCCESS}Configs copied!${RESET}"

    echo -e "${SUCCESS}Done!${RESET}"
}


function handle_ctrlc()
{
    echo -e "${ERROR}\nAborting install!${RESET}"
    exit
}

trap handle_ctrlc SIGINT
run_install


