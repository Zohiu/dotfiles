{
  lib,
  globals,
  pkgs,
  ...
}:
{
  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "com.github.tchx84.Flatseal"
      "com.bktus.gpgfrontend"
    ];

    home.packages = (
      with pkgs;
      [
        # Browsers
        firefox
        chromium
        ladybird
        tor-browser

        # Social
        discord
        signal-desktop

        # KDE stuff
        kdePackages.dolphin
        kdePackages.ark
        kdePackages.kate
        kdePackages.kservice
        kdePackages.kimageformats
        kdePackages.kdegraphics-thumbnailers
        kdePackages.ffmpegthumbs
        kdePackages.qtimageformats

        # Admin tools / Other
        qpwgraph
        gparted
      ]
    );

    programs.thunderbird = {
      enable = true;
      profiles = {
        "x7z6kjks.default" = {
          isDefault = true;
        };
      };
    };
  };
}
