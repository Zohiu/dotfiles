{...}:
let
    # === Audio MIME types ===
  audioMimes = [
    # Common formats
    "audio/mpeg" "audio/mp4" "audio/aac" "audio/ac3" "audio/x-mp3" "audio/x-m4a"
    "audio/x-ms-wma" "audio/flac" "audio/x-flac" "audio/x-ape" "audio/x-aiff"
    "audio/x-wav" "audio/vnd.wave" "audio/mod" "audio/x-it" "audio/x-s3m"
    "audio/x-stm" "audio/xm" "audio/basic" "audio/midi" "audio/x-midi"
    "audio/ogg" "audio/opus" "audio/vorbis" "audio/x-vorbis+ogg"
    "audio/vnd.rn-realaudio" "audio/webm"
    # Less common formats
    "audio/x-8svx" "audio/x-ape" "audio/x-mod" "audio/x-s3m" "audio/x-stm" "audio/xm"
    "audio/x-ms-wax" "audio/x-ms-wma" "audio/x-ogg" "audio/x-scpls" "audio/x-mpegurl"
    "audio/3gpp" "audio/3gpp2" "audio/x-matroska" "audio/x-flac" "audio/x-aiff"
    "audio/x-ape" "audio/x-m4a" "audio/x-ogg" "audio/x-scpls" "audio/x-mpegurl"
    "audio/opus" "audio/3gpp" "audio/3gpp2"
  ];

  # === Video MIME types ===
  videoMimes = [
    # Common formats
    "video/mp4" "video/x-matroska" "video/x-msvideo" "video/quicktime"
    "video/webm" "video/x-flv" "video/x-m4v" "video/x-vob"
    # Less common formats
    "video/3gpp" "video/3gpp2" "video/ogg" "video/x-ms-wmv" "video/x-ms-asf"
    "video/x-ms-wmx" "video/x-ms-vwx" "video/x-sgi-movie" "video/x-mng"
    "video/x-fli" "video/vnd.mpegurl" "video/vnd.ms-playready.media.pyv"
    "video/vnd.dece.video" "video/vnd.dece.sd" "video/vnd.dece.hd"
    "video/vnd.uvvu.mp4" "video/vnd.vivo" "video/x-f4v" "video/x-jpeg"
    "video/x-dv" "video/vnd.radgamettools.smacker" "video/vnd.radgamettools.bink"
  ];

  # === Image MIME types ===
  imageMimes = [
    # Common formats
    "image/png" "image/jpeg" "image/jpg" "image/gif" "image/bmp" "image/tiff"
    "image/webp" "image/svg+xml" "image/x-icon" "image/vnd.adobe.photoshop"
    # Less common formats
    "image/cgm" "image/heif" "image/heic" "image/jxr" "image/avif" "image/apng"
    "image/x-icns" "image/x-pcx" "image/x-png" "image/x-tiff" "image/x-xbitmap"
  ];

  # === Archive / Compressed files ===
  archiveMimes = [
    "application/zip" "application/x-tar" "application/x-bzip2"
    "application/x-gzip" "application/x-7z-compressed" "application/x-rar"
    "application/x-lzma" "application/x-lz4" "application/x-xz"
  ];

  # Helper function to map MIME types to a desktop app
  makeDefaults = mimeList: app: builtins.listToAttrs (map (mime: { name = mime; value = [ app ]; }) mimeList);

  # Generate defaults
  audioVideoDefaults = makeDefaults (audioMimes ++ videoMimes) "mpv.desktop";
  imageDefaults      = makeDefaults imageMimes "mpv.desktop";
in
{
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "dolphin.desktop" ];
      "text/html"       = [ "firefox.desktop" ];
    }
    // audioVideoDefaults
    // imageDefaults;
  };
}
