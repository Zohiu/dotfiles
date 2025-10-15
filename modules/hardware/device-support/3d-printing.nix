{
  lib,
  pkgs,
  globals,
  ...
}:
{
  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "com.ultimaker.cura"
    ];

    home.packages = (
      with pkgs;
      [
        orca-slicer
      ]
    );
  };
}
