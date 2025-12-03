# This file is meant for experimentation.
# Ideally, it should always be empty.
# If there's any content in here, it must be sorted out ASAP.

{
  lib,
  globals,
  pkgs,
  ...
}:
{
  # Temporary fix for an error that's out of my control.
  nixpkgs.overlays = [
    (self: super: {
      wrapGAppsHook = super.wrapGAppsHook3;
    })
  ];

  services.teamviewer.enable = true;

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [

    ];

    home.packages = (
      with pkgs;
      [

      ]
    );
  };
}
