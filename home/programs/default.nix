{ pkgs, pkgs-stable, inputs, ... }:
let
  # Lossless scaling app for steam
#   lsfg-vk = pkgs.stdenv.mkDerivation rec {
#     pname = "lsfg-vk";
#     version = "1.0.0";
#
#     src = pkgs.fetchzip {
#       url = "https://github.com/PancakeTAS/lsfg-vk/releases/download/v1.0.0/lsfg-vk-1.0.0-x86_64.zip";
#       sha256 = "1s5plyrj60kwjc00d8fl28gmkv9cd4jrx0y1g0a7s0mmrdk5vvnd"; # from nix-prefetch-url
#       stripRoot = false;
#     };
#
#     dontConfigure = true;
#     dontBuild = true;
#
#     installPhase = ''
#       # Install
#       mkdir -p $out/usr
#       cp -r bin lib share $out/
#       # chmod +x $out/usr/bin/*   # make binaries executable
#     '';
#   };
in
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
    # "org.prismlauncher.PrismLauncher"
    "io.github.MakovWait.Godots"
    "com.github.tchx84.Flatseal"
    "org.jdownloader.JDownloader"
    "org.vinegarhq.Sober"
    "io.github.betaflight.BetaflightConfigurator"

    { appId = "com.brave.Browser"; origin = "flathub";  }
  ];

  programs.thunderbird.enable = true;
  programs.thunderbird.profiles = {
      "x7z6kjks.default" = {
        isDefault = true;
      };
    };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-shaderfilter
      obs-pipewire-audio-capture
    ];
  };


  # Also need to rebuild nix to fix dolphin MIME
  home.packages = (
    with pkgs;
    [
      # GUI apps
      kitty
      ghostty

      mpv
      blueman
      firefox
      chromium
      ladybird
      tor-browser
      bitwarden-desktop
      qbittorrent
      # thunderbird
      gparted
      qalculate-gtk

      monero-gui
      xmrig
      clipnotify
      xclip

      # libsForQt5
      kdePackages.dolphin
      kdePackages.ark
      kdePackages.kate

      moonlight-qt
      gimp3
      discord
      virt-viewer
      osu-lazer
      umu-launcher
      protonplus
      prismlauncher

      obsidian
      signal-desktop
      cemu

      # tidal-hifi
      spotify
      blender
      blockbench
      bitwig-studio
      davinci-resolve
      sqlitebrowser
      trayscale
      r2modman
      audacity
      qpwgraph

      # jellyfin-media-player
      gnome-network-displays
      inkscape
      # betaflight-configurator

      # DVD/Blu-Ray ripping
      makemkv
      handbrake
      ffmpeg-full

      # tmp
      teamviewer

      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [
        "minecraft-development"
        "catppuccin-theme"
        "catppuccin-icons"
        "rainbow-brackets"
      ])

      jetbrains.pycharm-community-bin

      # Basics
      # rustup
      rustc
      cargo
      clang
      rustfmt
      pkg-config
      openssl
      rust-analyzer
      gnumake
      appimage-run
      gnupg
      wget
      curl
      direnv
      go
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pip
      ]))

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
      n-m3u8dl-re
      libqalculate

      # TUI apps
      micro
      nano
      btop
      wikiman
      lynx

      # Libs / Requirements
      sqlite
      wlr-randr
      wineWowPackages.stable
      kdePackages.kservice
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers
      kdePackages.ffmpegthumbs
      kdePackages.qtimageformats
      nixfmt-rfc-style

      # Job stuff
      teams-for-linux
    ]
  );
}
