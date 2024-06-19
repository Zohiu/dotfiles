# User info
EMAIL="mail@zohiu.de"
USERNAME="Zohiu" 

# Colors
NO_FORMAT="\033[0m"
RESET="\033[38;5;8m"
INFO="\033[38;5;87m"
SUCCESS="\033[38;5;154m"
ERROR="\033[38;5;9m"
TITLE="\033[38;5;213m"

# Packages
packages_system="linux-headers fish man-db expac reflector find-the-command fzf eza bat hwinfo gvfs networkmanager v4l2loopback-dkms v4l-utils v4l2loopback-utils slurp"
packages_gpu="xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau"
packages_audio="pipewire pavucontrol wireplumber pipewire-alsa pipewire-jack pipewire-pulse pipewire-audio ffmpeg pamixer alsa-utils"
packages_user="python-pip git neofetch neovim btop micro wine ffmpeg ffmpegthumbs ffmpegthumbnailer xclip pipewire-v4l2 flatpak radeontop sunshine-bin flatpak"

packages_desktop="qt6-wayland qt5-wayland xdg-desktop-portal xdg-desktop-portal-wlr polkit-gnome gnome-keyring swayfx wofi swaylock-effects grimshot mako nwg-launchers clipman wl-color-picker libnotify plasma-desktop kservice wlrobs-hg brightnessctl light libappindicator-gtk3"
packages_theme="lxappearance kvantum qt6ct ttf-font-awesome nerd-fonts noto-fonts-emoji"

packages_apps="visual-studio-code-bin qpwgraph gwenview ark mpv gedit nemo thunar dolphin vivaldi armcord modrinth-app spotify steam bitwig-studio nextcloud-client obs-studio obsidian blender inkscape"
packages_flatpak="org.gimp.GIMP"

# Linux user account
USER=$(whoami)
