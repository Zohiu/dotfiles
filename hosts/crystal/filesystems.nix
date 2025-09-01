{ lib, pkgs, ... }:

{
  services.openiscsi = {
    enable = true;
    enableAutoLoginOut = true;
    discoverPortal = "192.168.68.76:3260";
    name = "iqn.2024-09.com.nixos:crystal";
    # targets = [ "iqn.2005-10.org.freenas.ctl:steam" ];
    extraConfig = ''
      node.startup = automatic
      node.session.auth.authmethod = None

      # Performance improvement
      node.conn[0].max_recv_data_segment_length = 262144
      node.session.queue_depth -v 64
      node.session.nr_sessions -v 2
    '';
  };

  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-path/ip-192.168.68.76:3260-iscsi-iqn.2005-10.org.freenas.ctl:steam-lun-0-part1";
    fsType = "btrfs";
    options = [
        "rw"
        "noauto"
        "nofail"
        "users"
        "suid"
        "exec"
        "noatime"
        "nodiratime"
        "x-systemd.automount"
        "_netdev"
    ];
    neededForBoot = false;
  };
}
