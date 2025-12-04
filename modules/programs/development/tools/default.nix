{ lib, ... }:
{
  imports = [
    ./docker.nix
    ./git.nix
    ./godot.nix
    ./jetbrains.nix
    ./tabby.nix
    ./vscodium.nix
  ];
}
