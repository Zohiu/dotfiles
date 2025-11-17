{ lib, ... }:
{
  # Internet
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];
  services.resolved.enable = true;

  networking.nameservers = [
    "100.101.34.110" # Tailscale IP of my DNS server
    "100.100.100.100" # Tailscale MagicDNS
    # Fallbacks exist anyway, no need to specify them manually.
  ];
}
