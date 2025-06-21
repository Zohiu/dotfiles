{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
    ../amd.nix
  ];

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

  # Desktop streaming
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # VR streaming
  services.wivrn.enable = true;
  programs.envision = {
    enable = true;
    openFirewall = true; # This is set true by default
  };

  # Program overrides
  home-manager.users.samy.home.packages = [
    # Beat saber
    pkgs.bs-manager
  ];

  # Hyprland overrides
  home-manager.users.samy.wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-1, 1920x1080@60, 0x1080, auto"
      "DP-1, 2560x1440@165, 1920x720, auto"
      "DP-3, 1920x1080@60, 4480x1080, auto"

      "DP-2, 1920x1080@60, 4480x0, auto"
    ];

    env = [
      # Allow 2 gpus
      #"AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"
      #"WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"
    ];
  };

  # Version of first install
  home-manager.users.samy.home.stateVersion = "25.05";
  system.stateVersion = "25.05";
}
