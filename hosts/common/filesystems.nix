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
}
