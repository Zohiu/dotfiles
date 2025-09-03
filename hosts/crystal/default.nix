{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware.nix
    ./filesystems.nix
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
  services.wivrn.defaultRuntime = true;
  services.wivrn.package = pkgs-unstable.wivrn;
  services.wivrn.autoStart = true;
  services.wivrn.extraServerFlags = [ "--no-encrypt" ];
  services.wivrn.config.enable = true;
  home-manager.users.samy.xdg.configFile."wivrn/config.json".text = ''
    {
      "application": [
        "${pkgs-unstable.wlx-overlay-s}/bin/wlx-overlay-s"
      ],
      "bitrate": 60000000,
      "debug-gui": false,
      "encoders.disabled": [
        {
          "height": 1.0,
          "offset_x": 0.0,
          "offset_y": 0.0,
          "width": 1.0
        }
      ],
      "use-steamvr-lh": false
    }
  '';

  programs.envision = {
    enable = true;
    openFirewall = true; # This is set true by default
  };

  programs.corectrl.enable = true;

  # Program overrides
  home-manager.users.samy.home.packages = [
    pkgs.bs-manager
    pkgs.alsa-scarlett-gui
  ];

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
  home-manager.users.samy.wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-3, 1920x1080@60, 0x1080, auto"
      "DP-2, 2560x1440@165, 1920x720, auto"
      "DP-4, 1920x1080@60, 4480x1080, auto"

      "DP-3, 1920x1080@60, 4480x0, auto"
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
