{ pkgs, inputs, ... }:
{
  imports = [
    ./kitty
    ./micro
    ./mpv
    ./vscodium
    ./gnupg
    ./git
    ./fish
    ./btop
  ];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = false;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];

  services.flatpak.packages = [
    "com.bktus.gpgfrontend"
    "org.prismlauncher.PrismLauncher"
    "io.github.MakovWait.Godots"
    "com.github.tchx84.Flatseal"
  ];

  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (
    with pkgs;
    [
      # GUI apps
      kitty
      mpv
      blueman
      firefox
      chromium
      bitwarden-desktop
      qbittorrent

      libsForQt5.dolphin
      libsForQt5.ark
      libsForQt5.kate

      moonlight-qt
      gimp
      discord

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
      inkscape

      jetbrains.pycharm-community-bin
      jetbrains.idea-community-bin

      # Basics
      rustup
      gnumake
      appimage-run
      gnupg
      wget
      curl

      # Fun tools
      nitch
      neofetch

      # Command line tools
      tldr
      ncdu
      lsd
      fzf
      fd
      bat
      broot

      # TUI apps
      micro
      nano
      btop

      # Libs / Requirements
      sqlite
      wlr-randr
      wineWowPackages.stable
      kdePackages.kservice
      nixfmt-rfc-style
    ]
  );
}
