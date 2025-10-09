{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
    ../amd.nix
  ];

  networking.hostName = "tv";

  # Desktop streaming
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Version of first install
  home-manager.users.samy.home.stateVersion = "25.05";
  system.stateVersion = "25.05";
}
