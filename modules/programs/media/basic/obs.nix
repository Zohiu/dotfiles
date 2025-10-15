{ pkgs, globals, ... }:
{
  home-manager.users.${globals.user} = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-shaderfilter
        obs-pipewire-audio-capture
      ];
    };
  };

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
}
