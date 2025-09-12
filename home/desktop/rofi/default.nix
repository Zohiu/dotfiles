{ config, pkgs, ... }:
let
  rofi-calc-wayland = pkgs.rofi-calc.overrideAttrs (old: {
    buildInputs = map (i: if i == pkgs.rofi-unwrapped then pkgs.rofi-wayland else i) old.buildInputs;
  });
in
{
  home.packages = with pkgs; [
    rofi-wayland
    rofi-power-menu
    networkmanager_dmenu

    rofi-emoji-wayland
    rofi-top
    rofi-rbw-wayland # Bitwarden
    rofi-calc-wayland
    rofi-bluetooth
  ];

  xdg.configFile."rofi" = {
    source = ./config;
    recursive = true;
  };

}
