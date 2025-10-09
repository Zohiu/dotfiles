{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  hyprland,
  nix-flatpak,
  catppuccin,
  ...
}:

{
  imports = [
    ./filesystems.nix
    ./networking.nix
    ./mime.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Kernel modules
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  services.teamviewer.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Home manager
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.useUserPackages = true;
  home-manager.users.samy = {
    imports = [
      hyprland.homeManagerModules.default
      nix-flatpak.homeManagerModules.nix-flatpak
      ../../home
    ];
  };
  
  # Theme
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

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

  # Display Manager
  # services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Programs
  programs.steam.enable = true; # Needs to be in system conf for alvr.
  services.ollama.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.enable = true;

  # Lossless Scaling
  services.lsfg-vk = {
    enable = true;
    ui.enable = true; # installs gui for configuring lsfg-vk
  };

  # Drawing tablets
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  boot.blacklistedKernelModules = [
    "wacom"
    "hid_uclogic"
  ];

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

  services.flatpak.enable = true;

  # VERY IMPORTANT:
  # sudo tailscale up --operator=$USER
  services.tailscale.enable = true;

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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs-stable;
    };
  };

  # Make unmounted disks appear in dolphin
  services.udisks2.enable = true;

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

  # Allow dynamically linked executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    icu
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    # nerdfonts  # For icons
  ];

  # Fix unpopulated MIME menus in dolphin
  environment.etc."/xdg/menus/applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint # — Drivers for many different printers from many different vendors.
    pkgs.gutenprintBin # — Additional, binary-only drivers for some printers.
    pkgs.hplip # — Drivers for HP printers.
    pkgs.hplipWithPlugin # — Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.
    pkgs.postscript-lexmark # — Postscript drivers for Lexmark
    pkgs.samsung-unified-linux-driver # — Proprietary Samsung Drivers
    pkgs.splix # — Drivers for printers supporting SPL (Samsung Printer Language).
    pkgs.brlaser # — Drivers for some Brother printers
    pkgs.brgenml1lpr #  — Generic drivers for more Brother printers [1]
    pkgs.brgenml1cupswrapper  # — Generic drivers for more Brother printers [1]
    pkgs.cnijfilter2 # — Drivers for some Canon Pixma devices (Proprietary driver)	>
  ];
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All
      BrowseProtocols all
    '';
  };


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

  # Garbage collection - removes old generations and their packages.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;

  security.sudo.wheelNeedsPassword = false;
}
