{ globals, pkgs, ... }:

{
  # VERY IMPORTANT:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;

  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        trayscale
      ]
    );
  };
}
