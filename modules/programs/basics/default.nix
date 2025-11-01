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

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        appimage-run
        openssl
        gnupg
        wineWowPackages.stable

        # Git has its own config in modules/development/tools/git.nix.
        # However, since the flake needs git, it should always be available.
        git
      ]
    );

    # GPG
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
    '';
  };

  # Make unmounted disks appear in dolphin
  services.udisks2.enable = true;
}
