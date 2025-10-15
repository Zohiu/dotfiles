{
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  globals,
  ...
}:
let
  allFiles = lib.filesystem.listFilesRecursive ./.;
  nixFiles = builtins.filter (f: f != ./default.nix && lib.strings.hasSuffix ".nix" f) allFiles;
in
{
  imports = nixFiles;

  # Display Manager
  # services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Hyprland
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Fix blurry electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Additional packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    v4l-utils # For OBS virtual cam
    webkitgtk_4_1
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    # nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
