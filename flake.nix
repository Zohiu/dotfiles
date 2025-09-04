{
  description = "Zohiu's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # VR packages
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flatpak for home manager
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };

    # Framework stuff
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lossless scaling
    lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    lsfg-vk-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-xr,
      home-manager,
      nix-flatpak,
      catppuccin,
      hyprland,
      split-monitor-workspaces,
      nixos-hardware,
      fw-fanctrl,
      lsfg-vk-flake,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = system; };
      pkgs-stable = import nixpkgs-stable { system = system; };
    in
    {
      nixosConfigurations = {
        crystal = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit home-manager;
            inherit hyprland;
            inherit nix-flatpak;
            inherit catppuccin;
            inherit pkgs-stable;
          };
          modules = [
            nixpkgs-xr.nixosModules.nixpkgs-xr
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            ./hosts/crystal
            lsfg-vk-flake.nixosModules.default
          ];
        };

        shard = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit home-manager;
            inherit hyprland;
            inherit nix-flatpak;
            inherit catppuccin;
            inherit pkgs-stable;
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            fw-fanctrl.nixosModules.default
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            ./hosts/shard
            lsfg-vk-flake.nixosModules.default
          ];
        };

        tv = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit home-manager;
            inherit hyprland;
            inherit nix-flatpak;
            inherit catppuccin;
            inherit pkgs-stable;
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            ./hosts/tv
            lsfg-vk-flake.nixosModules.default
          ];
        };
      };
    };
}
