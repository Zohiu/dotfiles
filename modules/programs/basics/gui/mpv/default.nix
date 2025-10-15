{ globals, pkgs, ... }:
{
  home-manager.users.${globals.user} = {
    xdg.configFile."mpv" = {
      source = ./config;
      recursive = true;
    };

    home.packages = (
      with pkgs;
      [
        mpv
      ]
    );
  };
}
