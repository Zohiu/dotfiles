{ globals, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${globals.user}";
    group = "users";
    dataDir = "/home/${globals.user}";
    configDir = "/home/${globals.user}/.config/syncthing";
  };
}
