{ lib, ... }:
{
  imports = [
    ./bluetooth.nix
    ./connection.nix
    ./mounts.nix
    ./sunshine.nix
    ./syncthing.nix
    ./tailscale.nix
  ];
}
