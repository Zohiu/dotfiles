{
  lib,
  globals,
  pkgs,
  ...
}:
{
  programs.steam.enable = true;

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "org.vinegarhq.Sober"
    ];

    home.packages = (
      with pkgs;
      [
        spotify
      ]
    );
  };
}
