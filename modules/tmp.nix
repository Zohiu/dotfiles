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
