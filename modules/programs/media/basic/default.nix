{
  lib,
  pkgs,
  globals,
  ...
}:
let
  allFiles = lib.filesystem.listFilesRecursive ./.;
  nixFiles = builtins.filter (f: f != ./default.nix && lib.strings.hasSuffix ".nix" f) allFiles;
in
{
  imports = nixFiles;

  home-manager.users.${globals.user} = {
    services.flatpak.packages = [
      "org.jdownloader.JDownloader"
    ];

    home.packages = (
      with pkgs;
      [
        # Basic creation tools
        audacity
        gimp3

        # Media ripping / conversion
        makemkv
        handbrake
        ffmpeg-full
        n-m3u8dl-re
        qbittorrent
      ]
    );
  };
}
