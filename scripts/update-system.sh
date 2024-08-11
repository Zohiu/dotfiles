function run_update()
{
    trap handle_ctrlc SIGINT
    source ~/config/scripts/variables.sh

    echo -e "${TITLE}Welcome to Zohiu's arch update script!${RESET}"
    if [ "$EUID" == "0" ]
        then echo -e "${ERROR}Do not run this script as root!${RESET}"; exit
    fi

    source ~/config/scripts/variables.sh


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
    paru -Syu --noconfirm --needed $packages_system $packages_gpu $packages_audio $packages_user $packages_desktop $packages_theme $packages_apps
    sudo pacman -Rns --noconfirm $(pacman -Qtdq)

    # Flatpak
    flatpak install -y flathub $packages_flatpak
    flatpak update -y
    echo -e "${SUCCESS}Packages installed!${RESET}"

    # PhotoGIMP
    echo -e "${INFO}Setting up newest PhotoGIMP...${RESET}"
    wget -q --show-progress https://github.com/Diolinux/PhotoGIMP/releases/latest/download/PhotoGIMP.zip && unzip -q PhotoGIMP.zip
    cp -rd PhotoGIMP-master/.var ~/ && cp -rd PhotoGIMP-master/.local ~/
    rm PhotoGIMP.zip && rm -rd PhotoGIMP-master
    echo -e "${SUCCESS}PhotoGIMP set up!${RESET}"

    # Setup git globals
    echo -e "${INFO}Setting git globals...${RESET}"
    git config --global init.defaultBranch main
    git config --global user.email $EMAIL
    git config --global user.name $USERNAME
    echo -e "${SUCCESS}git globals set up!${RESET}"

    # Setup fish shell
    echo -e "${INFO}Setting up fish shell...${RESET}"
    sudo chsh -s /usr/bin/fish $USER
    if ! fish -c "type omf > /dev/null"; then
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
        fish -c "omf install https://github.com/catppuccin/fish"
    fi

    yes | fish -c 'fish_config theme save "Catppuccin Mocha"'
    echo -e "${SUCCESS}fish set up!${RESET}"

    # GTK themes
    echo -e "${INFO}Copying GTK themes...${RESET}"
    sudo cp -rd ~/config/gtk-themes/. /usr/share/themes/
    echo -e "${SUCCESS}GTK themes copied!${RESET}"

    # Fix dolphin MIME
    echo -e "${INFO}Setting up plasma-applications.menu for Dolphin...${RESET}"
    sudo ln -sf /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu
    kbuildsycoca6 --noincremental
    echo -e "${SUCCESS}plasma-applications.menu created!${RESET}"

    # Setup sunshine game streaming
    echo -e "${INFO}Setting up Sunshine server...${RESET}"
    echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | \
    sudo tee /etc/udev/rules.d/60-sunshine.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    sudo modprobe uinput
    sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))
    echo -e "${SUCCESS}Sunshine server set up.!${RESET}"

    # Setup yabridge VST
    echo -e "${INFO}Setting up yabridge...${RESET}"
    yabridgectl add "/home/$USER/.vst"
    yabridgectl sync --prune
    echo -e "${SUCCESS}yabridge server set up.!${RESET}"
    
    # Setup printing server
    echo -e "${INFO}Setting up print server...${RESET}"
    sudo systemctl enable --now cups
    sudo systemctl enable --now cups-browsed
    echo -e "${SUCCESS}print server set up.!${RESET}"
    
    # Services
    sudo systemctl enable --now xboxdrv
    sudo systemctl enable --now bluetooth
    sudo systemctl enable --now joycond
    
    # Setup VMWare network bridge
    echo -e "${INFO}Setting up VMWare networking...${RESET}"
    sudo systemctl enable --now vmware-networks.service
    echo -e "${SUCCESS}VMWare networking server set up.!${RESET}"
    
    # Setup autologin on tty1
    echo -e "${INFO}Enabling autologin on tty1...${RESET}"
    sudo systemctl set-default multi-user.target
    sudo systemctl enable getty@tty1
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    echo "[Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM" | \
    sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf > /dev/null
    echo -e "${SUCCESS}Autologin enabled!${RESET}"

    # Disable account lock on incorrect password
    echo -e "${INFO}Disabling account locking on incorrect password attempts..."
    echo "deny = 0" | sudo tee /etc/security/faillock.conf > /dev/null
    echo -e "${SUCCESS}Faillock disabled!${RESET}"

    # Change waiting for stop job time
    echo -e "${INFO}Changing default stop job timeout..."
    echo "DefaultTimeoutStopSec=5s" | sudo tee /etc/systemd/system.conf > /dev/null
    echo -e "${SUCCESS}Default stop job timeout changed!${RESET}"

    # Setup dolphin
    # https://wiki.dolphin-emu.org/index.php?title=Bluetooth_Passthrough#%22Failed_to_open_Bluetooth_device:_LIBUSB_ERROR_ACCESS%22

    # Move the actual config stuff
    echo -e "${INFO}Copying config files...${RESET}"
    source ~/config/scripts/update-config.sh
    echo -e "${SUCCESS}Configs copied!${RESET}"

    echo -e "${SUCCESS}Done!${RESET}"
}


function handle_ctrlc()
{
    echo -e "${ERROR}\nAborting install!${RESET}"
    exit
}
