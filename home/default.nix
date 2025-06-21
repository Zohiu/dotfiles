{ pkgs, inputs, ... }:
{

  imports = [
    ./programs
    ./scripts
    ./desktop
  ];

  home = {
    username = "samy";
    homeDirectory = "/home/samy";
  };

  programs.home-manager.enable = true;
}
