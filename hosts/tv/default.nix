{
  flake,
  inputs,
  globals,
  ...
}:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs { system = system; };
  pkgs-stable = import inputs.nixpkgs-stable { system = system; };
in
inputs.nixpkgs.lib.nixosSystem rec {
  specialArgs = {
    inherit inputs globals;
  };

  modules = [
    catppuccin.nixosModules.catppuccin
    nix-index-database.nixosModules.nix-index
    home-manager.nixosModules.home-manager

    ./hardware.nix

    "${flake}"
    "${flake}/modules/hardware/graphics/amd.nix"

    "${flake}/modules/desktop"

    "${flake}/modules/networking/connection.nix"
    "${flake}/modules/networking/bluetooth.nix"
    "${flake}/modules/networking/mounts.nix"
    "${flake}/modules/networking/sunshine.nix"
    "${flake}/modules/networking/tailscale.nix"

    "${flake}/modules/programs/basics"
    "${flake}/modules/programs/gaming"
    "${flake}/modules/programs/entertainment"
    "${flake}/modules/programs/media"
    "${flake}/modules/programs/scripts"

    {
      networking.hostName = "tv";

      # Version of first install
      home-manager.users.${globals.user}.home.stateVersion = "25.05";
      system.stateVersion = "25.05";
    }
  ];
}
