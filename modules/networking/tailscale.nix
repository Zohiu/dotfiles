{ globals, pkgs, ... }:

{
  # VERY IMPORTANT:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "100.100.100.100"
  ];

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        trayscale
      ]
    );
  };
}
