{
  lib,
  globals,
  pkgs,
  ...
}:
{
  imports = [
    ./3d-printing.nix
    ./drawing-tablet.nix
    ./printing.nix
    ./vr.nix
  ];
}
