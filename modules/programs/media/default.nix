{
  lib,
  globals,
  pkgs,
  ...
}:
{
  imports = [
    ./basic
    ./advanced
  ];

  programs.steam.enable = true;

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "org.vinegarhq.Sober"
    ];

    home.packages = (
      with pkgs;
      [
        osu-lazer
        umu-launcher
        protonplus
        prismlauncher

        # Emulation
        cemu

        # Modding
        r2modman
      ]
    );
  };
}
