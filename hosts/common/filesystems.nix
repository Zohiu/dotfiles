{ lib, pkgs, ... }:

{
  services.samba.enable = true;

  #boot.kernel.sysctl = {
  #  "vm.dirty_background_ratio" = 5;
  #  "vm.dirty_bytes" = "67108864";
  #  "vm.dirty_background_bytes" = "33554432";
  #};
  networking.extraHosts = ''
    truenas 192.168.68.76
  '';

  fileSystems = {
    "/mnt/truenas" = {
      device = "//truenas/samy/";
      fsType = "cifs";
      options = let
        automountOpts = lib.concatStringsSep ","
          [ "x-systemd.requires=tailscaled.service"
            "x-systemd.automount"
            "uid=1000"
            "gid=100"
            "sync"
            "users"
            "noauto"
            "suid"
            "exec"
            "mfsymlinks"
            "nocase"
            "cache=loose"
            "x-systemd.idle-timeout=60"
            "x-systemd.device-timeout=5s"
            "x-systemd.mount-timeout=5s"
          ];
      in [ "${automountOpts},credentials=/home/samy/.truenas-secrets" ];
    };
  };

  # Automount all removable devices as sync
  services.udisks2.enable = true;
  environment.systemPackages = with pkgs; [ udiskie ];
  systemd.tmpfiles.rules = [ "d /media 0755 root root -" ];
  #services.udev.extraRules = ''
  #  ACTION=="add|change", KERNEL=="sd[a-z][0-9]", ATTRS{removable}=="1", ENV{UDISKS_FILESYSTEM_SHARED}="1", ENV{UDISKS_MOUNT_OPTIONS_DEFAULTS}="sync"
  #'';
}
