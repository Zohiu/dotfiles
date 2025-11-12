{
  lib,
  globals,
  pkgs,
  ...
}:
let
  allFiles = lib.filesystem.listFilesRecursive ./.;
  nixFiles = builtins.filter (f: f != ./default.nix && lib.strings.hasSuffix ".nix" f) allFiles;
in
{
  imports = nixFiles;

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
