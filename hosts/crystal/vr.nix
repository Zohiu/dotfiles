{ config, pkgs, pkgs-stable, ... }:

{
  # VR streaming
  services.wivrn = {
    enable = true;
    defaultRuntime = true;
    package = pkgs.wivrn;
    # autoStart = true;
    # extraServerFlags = [ "--no-encrypt" ];  # I only use it in a local network.
    # config.enable = true;
  };

  home-manager.users.samy.xdg.configFile = {
    "wivrn/config.json".text = ''
      {
        "application": [
          "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s"
        ],
        "scale": [0.75, 0.5],
        "bitrate": 100000000,
        "debug-gui": false,
        "encoders.disabled": [
          {
            "height": 1.0,
            "offset_x": 0.0,
            "offset_y": 0.0,
            "width": 1.0
          }
        ],
        "use-steamvr-lh": false,
        "openvr-compat-path": "${pkgs.xrizer}/lib/xrizer"
      }
    '';

    "openvr/openvrpaths.vrpath".text = ''
      {"runtime":["${pkgs.xrizer}/lib/xrizer"],"version":1}
    '';

    "wlxoverlay/wayvr.conf.d/dashboard.yaml".text = ''
      dashboard:
        exec: "${pkgs.wayvr-dashboard}/bin/wayvr-dashboard"
        args: ""
        env: []
    '';

    "wlxoverlay/conf.d/timezones.yaml".text = ''
      timezones:
        - "Europe/Berlin"
    '';

    "wlxoverlay/config.yaml".text = ''
      # Prevents accidental dragging by pausing mouse events after clicking
      click_freeze_time_ms: 300

      keyboard_sound_enabled: true

      # Default overlay scaling
      keyboard_scale: 1.0
      desktop_view_scale: 1.0
      watch_scale: 1.0

      # Window interaction options
      allow_sliding: true
      realign_on_showhide: true

      # Pointer behavior
      focus_follows_mouse_mode: true
    '';

    "wlxoverlay/openxr_actions.json5".text = ''
      [
        // Oculus Touch Controller (Quest 2, Quest 3, Quest Pro)
        {
          profile: "/interaction_profiles/oculus/touch_controller",
          pose: {
            left: "/user/hand/left/input/aim/pose",
            right: "/user/hand/right/input/aim/pose"
          },
          haptic: {
            left: "/user/hand/left/output/haptic",
            right: "/user/hand/right/output/haptic"
          },
          click: {
            left: "/user/hand/left/input/trigger/value",
            right: "/user/hand/right/input/trigger/value"
          },
          grab: {
            left: "/user/hand/left/input/squeeze/value",
            right: "/user/hand/right/input/squeeze/value"
          },
          scroll: {
            left: "/user/hand/left/input/thumbstick/y",
            right: "/user/hand/right/input/thumbstick/y"
          },
          scroll_horizontal: {
            left: "/user/hand/left/input/thumbstick/x",
            right: "/user/hand/right/input/thumbstick/x"
          },
          show_hide: {
            double_click: false,
            left: "/user/hand/left/input/menu/click"
          },
          space_drag: {
            left: "/user/hand/left/input/menu/click"
          },
          space_reset: {
            double_click: true,
            left: "/user/hand/left/input/Y/click"
          },
          click_modifier_right: {
            left: "/user/hand/left/input/y/touch",
            right: "/user/hand/right/input/b/touch"
          },
          click_modifier_middle: {
            left: "/user/hand/left/input/x/touch",
            right: "/user/hand/right/input/a/touch"
          },
          move_mouse: {
            // Used with focus_follows_mouse_mode
            left: "/user/hand/left/input/trigger/touch",
            right: "/user/hand/right/input/trigger/touch"
          }
        }
      ]
    '';
  };
}
