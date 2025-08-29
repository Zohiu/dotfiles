{ lib, pkgs, ... }:

{
  services.samba.enable = true;
  fileSystems."/mnt/truenas" = {
    device = "//truenas/samy/";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.requires=tailscaled.service,x-systemd.automount,uid=1000,gid=100,users,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/samy/.truenas-secrets"];
  };
}
