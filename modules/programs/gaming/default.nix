{
  lib,
  globals,
  pkgs,
  ...
}:
{
  imports = [
    ./lossless-scaling.nix
    ./shadowpc.nix
  ];

  programs.steam.enable = true;
  programs.corectrl.enable = true;

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "org.vinegarhq.Sober"
    ];

    home.packages = (
      with pkgs;
      [
        osu-lazer
        protonplus
        prismlauncher
        moonlight-qt

        # Emulation
        cemu

        # Modding
        r2modman
        satisfactorymodmanager
      ]
    );
  };
}
