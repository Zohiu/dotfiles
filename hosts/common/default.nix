 
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];
  networking.nameservers = [
    "192.168.68.250"
    "1.1.1.1"
    "100.100.100.100"
  ];
  services.resolved.enable = true;

  # Locale options
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.xkb.layout = "de";
  console.keyMap = "de";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Display Manager
  services.xserver.displayManager.gdm.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.steam.enable = true;  # Needs to be in system conf for alvr.

  # Hyprland
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  programs.hyprland ={
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Fix blurry electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Services
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # VR streaming
  services.wivrn.enable = true;
  programs.envision = {
    enable = true;
    openFirewall = true; # This is set true by default
  };

  services.flatpak.enable = true;
  # VERY IMPORTANT:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;
  services.blueman.enable = true;
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "samy";
    group = "users";
    dataDir = "/home/samy";
    configDir = "/home/samy/.config/syncthing";
  };

  users.users.samy = {
    isNormalUser = true;
    description = "Samy";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Additional packages (nix search <pkg>)
  environment.systemPackages = with pkgs; [
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    # nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
}
