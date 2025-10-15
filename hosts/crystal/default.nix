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
    inherit flake inputs globals;
  };

  modules = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.catppuccin.nixosModules.catppuccin
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager
    inputs.lsfg-vk-flake.nixosModules.default

    ./hardware.nix
    ./filesystems.nix

    "${flake}"
    "${flake}/modules/hardware/graphics/amd.nix"

    "${flake}/modules/desktop"
    "${flake}/modules/hardware/device-support"
    "${flake}/modules/networking"
    "${flake}/modules/programs"
    {
      networking.hostName = "crystal";

      # Remap right super to alt gr
      services.keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = [ "*" ];
            settings = {
              main = {
                rightmeta = "rightalt";
              };
              otherlayer = { };
            };
          };
        };
      };

      # Sample rate
      services.pipewire.extraConfig = {
        pipewire = {
          # Will create a config in /etc/pipewire/pipewire.conf.d/
          "10-custom-audio-rate" = {
            "context.properties" = {
              "default.clock.rate" = 192000; # Or 44100, 48000, 96000, 192000, etc.
              "resample.quality" = 10;
            };
          };
        };

        pipewire-pulse."10-pulse-192khz" = {
          "pulse.properties" = {
            "audio.channels" = 2;
            "audio.format" = "S32LE";
            "default.sample.rate" = 192000;
            "default.channels" = 2;
            "default.sample.format" = "S32LE";
          };
        };
      };

      # Hyprland overrides
      home-manager.users.${globals.user} = {
        home.stateVersion = "25.05";

        wayland.windowManager.hyprland.settings = {
          monitor = [
            "HDMI-A-1, 1920x1080@60, 0x1080, auto"
            "DP-1, 2560x1440@120, 1920x720, auto"
            "DP-2, 1920x1080@60, 4480x1080, auto"
          ];
        };
      };

      system.stateVersion = "25.05";
    }
  ];
}
