{
  config,
  lib,
  pkgs,
  ...
}:
let
  clipsync = pkgs.writeShellScriptBin "clipsync" ''
    #!/usr/bin/env sh
    #
    # Two-way clipboard syncronization between Wayland and X11, with cliphy support!
    # !! Recommended use: Drop this file off @ /usr/local/bin/clipsync && make it executable
    # Requires: wl-clipboard, xclip, clipnotify.
    # Modified from: https://github.com/hyprwm/Hyprland/issues/6132#issuecomment-2127153823
    #
    # Usage:
    #   clipsync watch [with-notifications|without-notifications] - run in background.
    #   clipsync stop - kill all background processes.
    #   echo -n any | clipsync insert [with-notifications|without-notifications] - insert clipboard content from stdin.
    #   clipsync help - display help information.
    #
    # Workaround for issue:
    # "Clipboard synchronization between wayland and xwayland clients broken"
    # https://github.com/hyprwm/Hyprland/issues/6132
    #
    # Also pertains to:
    # https://github.com/hyprwm/Hyprland/issues/6247
    # https://github.com/hyprwm/Hyprland/issues/6443
    # https://github.com/hyprwm/Hyprland/issues/6148

    # Updates clipboard content of both Wayland and X11 if current clipboard content differs.
    # Usage: echo -e "1\n2" | clipsync insert [with-notifications|without-notifications]
    insert() {
      # Read all the piped input into variable.
      value=$(cat)
      wValue=$(wl-paste -n 2>/dev/null || echo "")
      xValue=$(xclip -o -selection clipboard 2>/dev/null || echo "")

      notify() {
        if [ "$1" != "without-notifications" ]; then
      #    notify-send -u low -c clipboard "$2" "$value"
          echo
        fi
      }

      # discard if empty
      if [ -z "$value" ]; then
        exit
      fi

      if command -v cliphist >/dev/null 2>&1; then
        clipHistLast=$(cliphist list | head -1 | cliphist decode)
        if [ "$value" != "$clipHistLast" ]; then
          notify "$1" "Failsafe Copy"
          echo -n "$value" | wl-copy
          echo -n "$value" | cliphist store
        fi
      fi


      if [ "$value" == "$wValue" ]; then
        if [ "$value" != "$xValue" ]; then
          notify "$1" "Wayland"
          echo -n "$value" | xclip -selection clipboard
          # Add to cliphist if it's installed
          if command -v cliphist >/dev/null 2>&1; then
            echo -n "$value" | cliphist store
          fi
          exit
        fi
      fi

      if [ "$value" == "$xValue" ]; then
        if [ "$value" != "$wValue" ]; then
          notify "$1" "X11"
          echo -n "$value" | wl-copy
          # Add to cliphist if it's installed
          if command -v cliphist >/dev/null 2>&1; then
            echo -n "$value" | cliphist store
          fi
          exit
        fi
      fi
    }

    # Watch for clipboard changes and synchronize between Wayland and X11
    # Usage: clipsync watch [with-notifications|without-notifications]
    watch() {
      # Add a small delay to ensure clipboard services are initialized
      sleep 1

      notification_mode="$1"
      if [ -z "$notification_mode" ]; then
          notification_mode="with-notifications"
      fi

      # Wayland -> X11
      wl-paste --type text --watch bash -c "clipsync insert $notification_mode" &

      # X11 -> Wayland
      while clipnotify; do
        xclip -o -selection clipboard 2>/dev/null | clipsync insert "$notification_mode"
      done &
    }

    # Kill all background processes related to clipsync
    stop_clipsync() {
      pkill -f "wl-paste --type text --watch"
      pkill clipnotify
      pkill -f "xclip -selection clipboard"
      pkill -f "clipsync insert"
    }

    help() {
      cat << EOF
    clipsync - Two-way clipboard synchronization between Wayland and X11, with cliphist support

    Usage:
      clipsync watch [with-notifications|without-notifications]
        Run clipboard synchronization in the background.
        Options:
          with-notifications (default): Show desktop notifications for clipboard changes.
          without-notifications: Operate silently without notifications.

      clipsync stop
        Stop all background processes related to clipsync.

      echo -n "text" | clipsync insert [with-notifications|without-notifications]
        Insert clipboard content from stdin.
        Notification options work the same as in the watch command.

      clipsync help
        Display this help information.

    Requirements: wl-clipboard, xclip, clipnotify
    Optional: cliphist (for Hyprland users)
    EOF
    }

    case "$1" in
      watch)
        watch "$2"
        ;;
      stop)
        stop_clipsync
        ;;
      insert)
        insert "$2"
        ;;
      help)
        help
        ;;
      *)
        echo "Usage: $0 {watch [with-notifications|without-notifications]|stop|insert [with-notifications|without-notifications]|help}"
        echo "Run '$0 help' for more information."
        exit 1
        ;;
    esac
  '';

  rust_create_project = pkgs.writeShellScriptBin "rust_create_project" ''
    nix --accept-flake-config run github:juspay/omnix -- init github:srid/rust-nix-template -o $1
  '';

  lock_and_sleep = pkgs.writeShellScriptBin "lock_and_sleep" ''
    hyprlock & systemctl suspend
  '';

  remount_force_all = pkgs.writeShellScriptBin "remount_force_all" ''
    sudo umount -l /mnt/*
    rebuild test
  '';

  cava-internal = pkgs.writeShellScriptBin "cava-internal" ''
    cava -p ~/.config/cava/config1 | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';

  wallpaper_random = pkgs.writeShellScriptBin "wallpaper_random" ''
    bash -c "swww img $(find ~/dotfiles/home/wallpapers/ -type f | shuf -n 1)"
  '';

  aniworld = pkgs.writeShellScriptBin "aniworld" ''
    nix-shell -p pipx yt-dlp --run "pipx install aniworld && /home/samy/.local/bin/aniworld"
  '';

  ytdl = pkgs.writeShellScriptBin "ytdl" ''
    nix-shell -p yt-dlp --run "yt-dlp '$1' --add-metadata --cookies cookies.txt --embed-thumbnail -o '%(channel)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
  '';

  wiicapture = pkgs.writeShellScriptBin "wiicapture" ''
    pw-loopback -C alsa_input.usb-MACROSILICON_USB3.0_Capture-02.analog-stereo &

    mpv av://v4l2:$1 --demuxer=lavf --demuxer-lavf-o=video_size=1280x720,framerate=60,input_format=mjpeg --profile=low-latency --keepaspect=no --vf="hqdn3d=3.0:2.0:4.0:3.0,pp=lb,unsharp=5:5:0.8"

    pkill pw-loopback
  '';

  brightness = pkgs.writeShellScriptBin "brightness" ''
    # Taken from https://github.com/MasterDevX/linux-backlight-controller/tree/master
    backlight_class=/sys/class/backlight/
    monitor=DP-1

    for device in $backlight_class*; do
        if ls -l $device | grep -q $monitor; then
            backlight_device=$device
            break
        fi
    done

    actual_brightness=$(cat $backlight_device/brightness)
    max_brightness=$(cat $backlight_device/max_brightness)
    brightness=$backlight_device/brightness

    step=$(($max_brightness * $2 / 100))
    if [ $1 == "+" ] || [ $1 == "-" ]; then
        new_brightness=$(($actual_brightness $1 $step))
        if [ $new_brightness -lt 0 ]; then
            new_brightness=0
        fi
        if [ $new_brightness -gt $max_brightness ]; then
            new_brightness=$max_brightness
        fi
        echo $new_brightness > $brightness
    fi
  '';

in
{
  home.packages = with pkgs; [
    clipsync
    lock_and_sleep
    remount_force_all
    cava-internal
    wallpaper_random
    aniworld
    ytdl
    wiicapture
    brightness
    rust_create_project
  ];
}
