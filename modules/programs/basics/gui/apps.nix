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

        nemo-with-extensions
        nemo-preview
        nemo-fileroller
        nemo-seahorse

        file-roller
        mate.pluma

        # Admin tools / Other
        qpwgraph
        gparted
      ]
    );

    dconf = {
      settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "kitty";
        };
      };
    };

    xdg.configFile."gtk-3.0/bookmarks".text = ''
      file:///home/${globals.user}/dotfiles Dotfiles
      file:///home/${globals.user}/Downloads Downloads
      file:///home/${globals.user}/Development Development
      file:///home/${globals.user}/Documents Documents
      file:///home/${globals.user}/Pictures Pictures
      file:///home/${globals.user}/Videos Videos
      file:///home/${globals.user}/Music Music
    '';

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
