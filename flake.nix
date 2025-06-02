 
{
  description = "Zohiu's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Framework stuff
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, nixos-hardware, fw-fanctrl, ... }:
    let
      systems = [ "x86_64-linux" ];
      forEachSystem = f: builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) systems);
    in {
      nixosConfigurations = {
        zohiupc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/zohiupc

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.samy.imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                ./home/home.nix
              ];
            }
          ];
        };

        framework = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            fw-fanctrl.nixosModules.default
            ./hosts/framework

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
               home-manager.users.samy.imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                ./home/home.nix
              ];
            }
          ];
        };
      };
    };
}
