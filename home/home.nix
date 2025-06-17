{ pkgs, inputs, ... }: {

  imports = [
    ./programs
    ./scripts
    ./desktop
    ./vr.nix
  ];

  home = {
    username = "samy";
    homeDirectory = "/home/samy";
  };

  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://flathub.org/repo/flathub.flatpakrepo";
  }];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = false;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.packages = [
    "com.bktus.gpgfrontend"
    "org.prismlauncher.PrismLauncher"
    "io.github.MakovWait.Godots"
    "com.github.tchx84.Flatseal"
  ];

  # BSManager:
  # sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # sudo flatpak install BSManager-1.5.3-x86_64.flatpak

  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (with pkgs; [
    # GUI apps
    kitty
    mpv
    blueman
    nemo-with-extensions
    firefox
    chromium
    bitwarden-desktop
    qbittorrent

    wineWowPackages.stable

    libsForQt5.dolphin

    libsForQt5.ark
    libsForQt5.kate
    moonlight-qt
    gimp
    discord
    # fuck libreoffice
    # libreoffice-fresh
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

    # Beat saber
    bs-manager

    jellyfin-media-player
    gnome-network-displays
    inkscape

    jetbrains.pycharm-community-bin
    jetbrains.idea-community-bin

    # Command line utils
    fish
    wlr-randr
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
    gnupg
    # pinentry

    # TUI apps
    micro
    nano
    btop

    # Libs / Requirements
    kdePackages.kservice
  ]);

  programs.git = {
    enable = true;
    userName  = "Zohiu";
    userEmail = "mail@zohiu.de";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      commit.gpgsign = true;
      user.signingkey = "F93EC485BC2ED258";
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
