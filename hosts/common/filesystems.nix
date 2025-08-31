{ lib, pkgs, ... }:

{
  services.samba.enable = true;
  fileSystems."/mnt/truenas" = {
    device = "//truenas/samy/";
    fsType = "cifs";
    options = let
      automountOpts = lib.concatStringsSep ","
        [ "x-systemd.requires=tailscaled.service"
          "x-systemd.automount"
          "uid=1000"
          "gid=100"
          "users"
          "noauto"
          "suid"
          "exec"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
        ];
    in [ "${automountOpts},credentials=/home/samy/.truenas-secrets" ];
  };
}
