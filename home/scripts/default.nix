{
  config,
  lib,
  pkgs,
  ...
}:
let
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
    nix-shell -p yt-dlp --run "yt-dlp '$1' --add-metadata --embed-thumbnail -o '%(channel)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
  '';


  fixbrightness = pkgs.writeShellScriptBin "fixbrightness" ''
    sudo chmod a+rw /sys/class/backlight/amdgpu_bl1/brightness
  '';

  brightness = pkgs.writeShellScriptBin "brightness" ''
    # Taken from https://github.com/MasterDevX/linux-backlight-controller/tree/master
    backlight_class=/sys/class/backlight/
    monitor=$(xrandr | grep -w connected | awk '{print $1}')

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
    lock_and_sleep
    remount_force_all
    cava-internal
    wallpaper_random
    aniworld
    ytdl
    fixbrightness
    brightness
  ];
}
