{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."cava" = {
    source = ./config;
    recursive = true;
  };

}
