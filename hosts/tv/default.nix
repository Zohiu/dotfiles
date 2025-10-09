{ inputs, globals, ... }:
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
    ../common
    ../amd.nix
    {
      networking.hostName = "tv";

      # Desktop streaming
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      # Version of first install
      home-manager.users.${globals.user}.home.stateVersion = "25.05";
      system.stateVersion = "25.05";
    }
  ];
}