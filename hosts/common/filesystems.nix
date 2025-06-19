{ ... }:

{
  # Using IP for nfs to fix slow unmounting on shutdown.
  # These are internal tailnet IPs btw.
  fileSystems."/mnt/data" = {
    device = "100.96.28.102:/mnt/main/data";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=60"
      "hard"
      "rw"
      "async"
      "nfsvers=4.2"
      "_netdev"
      "x-systemd.requires=tailscaled.service"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "100.96.28.102:/mnt/main/games";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=60"
      "hard"
      "rw"
      "async"
      "nfsvers=4.2"
      "_netdev"
      "x-systemd.requires=tailscaled.service"
    ];
  };
}
