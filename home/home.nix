{ pkgs, ... }: {

  imports = [
    ./programs
    ./scripts
    ./desktop
  ];

  home = {
    username = "samy";
    homeDirectory = "/home/samy";
  };

  nixpkgs.config.allowUnfree = true;

  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (with pkgs; [
    # GUI apps
    kitty
    mpv
    blueman
    nemo-with-extensions
    firefox
    chromium
    alvr
    bitwarden-desktop
    libsForQt5.dolphin
    libsForQt5.ark
    libsForQt5.kate
    moonlight-qt
    gimp
    libreoffice-fresh
    obs-studio
    obsidian
    signal-desktop
    tidal-hifi
    blender
    blockbench
    bitwig-studio
    davinci-resolve
    sqlitebrowser
    trayscale
    r2modman
    audacity
    qpwgraph

    jellyfin-media-player
    gnome-network-displays

    jetbrains.pycharm-community-bin
    jetbrains.idea-community-bin

    # Command line utils
    fish
    wlr-randr
    git
    nitch
    neofetch
    wget
    rustup
    gnumake
    catimg
    curl
    appimage-run
    sqlite
    (python312.withPackages (p: with p; [
      build
    ]))

    # TUI apps
    micro
    nano
    btop

  ]);

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
