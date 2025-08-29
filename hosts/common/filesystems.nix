{ lib, pkgs, ... }:

{
  fileSystems."/mnt/truenas" = {
    device = "//truenas/samy/";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.requires=tailscaled.service,x-systemd.automount,users,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/samy/.truenas-secrets"];
  };

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "samy";
    group = "users";
    setuid = true;
  };
}
