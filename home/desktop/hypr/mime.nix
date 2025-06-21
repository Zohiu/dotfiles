{ pkgs, ... }:

let
  mimeappsText = ''
    [Default Applications]
    # Web Browser
    default-web-browser=firefox.desktop;
    x-scheme-handler/http=firefox.desktop;
    x-scheme-handler/https=firefox.desktop;
    x-scheme-handler/about=firefox.desktop;
    x-scheme-handler/unknown=firefox.desktop;

    # Directories
    inode/directory=dolphin.desktop;

    # Text Files
    text/*=kate.desktop;
    text/plain=kate.desktop;
    text/html=firefox.desktop;

    # Images
    image/*=mpv.desktop;
    image/jpeg=mpv.desktop;
    image/png=mpv.desktop;
    image/gif=mpv.desktop;
    image/bmp=mpv.desktop;
    image/svg+xml=mpv.desktop;
    image/webp=mpv.desktop;

    # Video
    video/*=mpv.desktop;
    video/mp4=mpv.desktop;
    video/x-matroska=mpv.desktop;
    video/webm=mpv.desktop;
    video/avi=mpv.desktop;
    video/x-flv=mpv.desktop;

    # Audio
    audio/*=mpv.desktop;
    audio/mpeg=mpv.desktop;
    audio/ogg=mpv.desktop;
    audio/flac=mpv.desktop;
    audio/wav=mpv.desktop;

    # Archives
    application/zip=ark.desktop;
    application/x-tar=ark.desktop;
    application/x-gzip=ark.desktop;
    application/x-bzip2=ark.desktop;
    application/x-xz=ark.desktop;
    application/x-7z-compressed=ark.desktop;
  '';

  generateMimeinfoCache = pkgs.runCommand "mimeinfo-cache" {
    buildInputs = [ pkgs.gawk ];
  } ''
    mkdir -p $out

    # write the mimeapps.list contents to a temporary file
    echo "${mimeappsText}" > mimeapps.list

    echo "[MIME Cache]" > $out/mimeinfo.cache

    gawk -F '=' '
      /^\[Default Applications\]/ { in_defaults=1; next }
      /^\[/ { in_defaults=0 }
      in_defaults && NF == 2 {
        gsub(/;/, "", $2)
        print $1 "=" $2 ";"
      }
    ' mimeapps.list >> $out/mimeinfo.cache
  '';
in
{
  home.file.".config/mimeapps.list".text = mimeappsText;
  home.file.".local/share/applications/mimeinfo.cache".source = "${generateMimeinfoCache}/mimeinfo.cache";
}
