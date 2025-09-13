{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./mime.nix
  ];

  # Takes inputs from flake.nix!
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = {
      exec-once = [
        "sunshine"
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "dunst"
        "easyeffects --gapplication-service"
        "swww init && exec wallpaper_random"
        "while true; do sleep 300; wallpaper_random; done"
        "wl-paste -t text --watch clipman store --no-persist"
        "systemctl --user start hyprpolkitagent"
        "hyprpaper"
      ];

      exec = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "pkill waybar; waybar"
        "XDG_MENU_PREFIX=plasma- kbuildsycoca6"
      ];

      input = {
        kb_layout = "de";
        kb_options = "";
        kb_variant = "";
        kb_model = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 1.0;
        accel_profile = "flat";
        force_no_accel = true;
        natural_scroll = false;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.8;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(e170ffee) rgba(70a0ffee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "ease,0.4,0.02,0.21,1"
        ];

        animation = [
          "windows,1,3.5,ease,popin"
          "windowsOut,1,3.5,ease,popin"
          "border,1,6,default"
          "fade,1,3,ease"
          "workspaces,1,3.5,ease,slidefade"
        ];
      };

      xwayland = {
        force_zero_scaling = true;
      };

      misc = {
        vfr = true; # Lower framerate when no movement.
      };

      render = {
        direct_scanout = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      #gestures = {
      #  workspace_swipe = false;
      #};

      plugin = {
        "split-monitor-workspaces" = {
          count = 10;
          keep_focused = true;
          enable_notifications = false;
          enable_persistent_workspaces = false;
        };
        "dynamic-cursors" = {
          enabled = true;
          mode = "tilt";
          tilt = {
            limit = 7500;
          };
          shake = {
            enabled = true;
          };
        };
      };

      layerrule = [
        "noanim,^(rofi)$"
      ];

      windowrulev2 = [
        "tile,class:^(Godot)$"
        "float,title:\\(DEBUG\\)$"
        "center,title:\\(DEBUG\\)$"
        "size 900 600,title:\\(DEBUG\\)$"

        "noinitialfocus, class:(jetbrains-)(.*), floating:1"

        "float,class:org.pulseaudio.pavucontrol"
        "size 800 600,class:org.pulseaudio.pavucontrol"
      ];

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, F, fullscreen"
        "$mainMod, RETURN, exec, kitty"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, X, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
        "$mainMod, I, exec, rofi-main-menu"
        "$mainMod, E, exec, dolphin"
        "$mainMod, SPACE, togglefloating"
        "$mainMod, d, exec, rofi -theme theme -show drun"
        "$mainMod, J, togglesplit"

        "$mainMod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"

        ",XF86AudioMicMute,exec,pamixer --default-source -t"
        ",XF86MonBrightnessDown,exec,bash brightness - 5"
        ",XF86MonBrightnessUp,exec,bash brightness + 5"
        ",XF86AudioMute,exec,pamixer -t"
        ",XF86AudioLowerVolume,exec,pamixer -d 5"
        ",XF86AudioRaiseVolume,exec,pamixer -i 5"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl play-pause"

        "SUPER,Tab,cyclenext"
        "SUPER,Tab,bringactivetotop"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, split-workspace, 1"
        "$mainMod, 2, split-workspace, 2"
        "$mainMod, 3, split-workspace, 3"
        "$mainMod, 4, split-workspace, 4"
        "$mainMod, 5, split-workspace, 5"
        "$mainMod, 6, split-workspace, 6"
        "$mainMod, 7, split-workspace, 7"
        "$mainMod, 8, split-workspace, 8"
        "$mainMod, 9, split-workspace, 9"
        "$mainMod, 0, split-workspace, 10"

        "$mainMod SHIFT, 1, split-movetoworkspace, 1"
        "$mainMod SHIFT, 2, split-movetoworkspace, 2"
        "$mainMod SHIFT, 3, split-movetoworkspace, 3"
        "$mainMod SHIFT, 4, split-movetoworkspace, 4"
        "$mainMod SHIFT, 5, split-movetoworkspace, 5"
        "$mainMod SHIFT, 6, split-movetoworkspace, 6"
        "$mainMod SHIFT, 7, split-movetoworkspace, 7"
        "$mainMod SHIFT, 8, split-movetoworkspace, 8"
        "$mainMod SHIFT, 9, split-movetoworkspace, 9"
        "$mainMod SHIFT, 0, split-movetoworkspace, 10"

        "$mainMod SHIFT, LEFT, movewindow, l"
        "$mainMod SHIFT, RIGHT, movewindow, r"
        "$mainMod SHIFT, UP, movewindow, u"
        "$mainMod SHIFT, DOWN, movewindow, d"

        "$mainMod CONTROL, LEFT, resizeactive, -30 0"
        "$mainMod CONTROL, RIGHT, resizeactive, 30 0"
        "$mainMod CONTROL, UP, resizeactive, 0 -30"
        "$mainMod CONTROL, DOWN, resizeactive, 0 30"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "ALT, mouse:272, resizewindow"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      after_sleep_cmd = "sudo systemctl restart NetworkManager";

      inhibit_sleep = 1;
    };
  };

  services.hyprpolkitagent.enable = true;

  services.clipman.enable = true;
  home.packages = with pkgs; [
    xdg-desktop-portal
    grim
    slurp # Screenshots
    hyprlock
    hyprpaper
    swww
    pavucontrol
    easyeffects
    wl-clipboard
    pamixer
    networkmanagerapplet
    papirus-folders
  ];

  #qt = {
  #  enable = true;
  #  platformTheme.name = "kde";
  #};

  home = {
    sessionVariables = {
      EDITOR = "kate";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      __GL_VRR_ALLOWED = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      # AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
      QT_STYLE_OVERRIDE = "darkly";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = (
        pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          variant = "mocha";
        }
      ); # tokyo-night-gtk
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  qt = {
    enable = true;
    style.package = with pkgs; [
      darkly-qt5
      darkly
      catppuccin-qt5ct
      catppuccin
      dracula-qt5-theme
      dracula-theme
    ];
    platformTheme.name = "qtct";
    kde.settings.kdeglobals.General.TerminalApplication = "kitty";
    kde.settings.kdeglobals.Icons.Theme = "Papirus-Dark";
    kde.settings.kdeglobals.UiSettings.ColorScheme = "qt6ct";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "catppuccin-mocha-mauve-standard";
    };
  };

  xdg.configFile."hypr" = {
    source = ./config;
    recursive = true;
  };

}
