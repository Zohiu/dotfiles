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
        # Crypto stuff
        monero-gui
        xmrig
        alsa-scarlett-gui
      ]
    );
  };
}
