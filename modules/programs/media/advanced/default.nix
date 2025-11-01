{
  lib,
  pkgs,
  globals,
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
        # Advanced creation tools
        blender
        blockbench
        bitwig-studio
        davinci-resolve
        inkscape
        orca-slicer
      ]
    );
  };
}
