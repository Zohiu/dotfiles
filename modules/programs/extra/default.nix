{
  lib,
  globals,
  pkgs,
  ...
}:
{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        # Crypto stuff
        monero-gui
        xmrig
        alsa-scarlett-gui
      ]
    );
  };
}
