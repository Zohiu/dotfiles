function run_update()
{
    trap handle_ctrlc SIGINT
    source ~/config/scripts/variables.sh

    echo -e "${TITLE}Welcome to Zohiu's arch update script!${RESET}"
    if [ "$EUID" == "0" ]
        then echo -e "${ERROR}Do not run this script as root!${RESET}"; exit
    fi

    source ~/config/scripts/variables.sh

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
    source ~/config/scripts/update-config.sh
    echo -e "${SUCCESS}Configs copied!${RESET}"

    echo -e "${SUCCESS}Done!${RESET}"
}


function handle_ctrlc()
{
    echo -e "${ERROR}\nAborting install!${RESET}"
    exit
}
