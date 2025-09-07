{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common
    ../amd.nix
  ];

  networking.hostName = "shard";

  hardware.framework.enableKmod = true;
  services.fwupd.enable = true;

  # Suspend when laptop lid is closed
  services.logind = {
    lidSwitch = "suspend";
  };

  # Ignore the power key
  #services.logind.extraConfig = ''
  #  # don’t shutdown when power button is short-pressed
  #  HandlePowerKey=ignore
  #  HandleSuspendKey=ignore
  #  HandleHibernateKey=ignore
  #'';

  services.fprintd.enable = true;

  # Latptop adjustments
  services.cpupower-gui.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  boot.kernelParams = [
    # Tickless / scheduler tuning
    "nohz_full=1-12"          # Replace N with your last CPU (exclude CPU0)
    "rcu_nocbs=1-12"          # Offload RCU callbacks from isolated CPUs
    # AMD GPU power management
    "amdgpu.dc=1"
    "amdgpu.deep_color=1"
    "amdgpu.runpm=1"
  ];

  #services.auto-cpufreq.enable = false; # Might conflict with tlp, but is allowed to be used at the same time.
  #services.auto-cpufreq.settings = {
  #  battery = {
  #    governor = "powersave";
  #    turbo = "never";
  #  };
  #  charger = {
  #    governor = "performance";
  #    turbo = "auto";
  #  };
  #};

  # Enable fw-fanctrl (framework fancontrol)
  # programs.fw-fanctrl.enable = true;

  # Add a custom config
#   programs.fw-fanctrl.config = {
#     defaultStrategy = "lazy";
#     strategies = {
#       "lazy" = {
#         fanSpeedUpdateFrequency = 5;
#         movingAverageInterval = 30;
#         speedCurve = [
#           {
#             temp = 0;
#             speed = 0;
#           }
#           {
#             temp = 40;
#             speed = 15;
#           }
#           {
#             temp = 65;
#             speed = 25;
#           }
#           {
#             temp = 70;
#             speed = 35;
#           }
#           {
#             temp = 75;
#             speed = 50;
#           }
#           {
#             temp = 85;
#             speed = 100;
#           }
#         ];
#       };
#     };
#   };

  # Home Manager overrides
  home-manager.users.samy.wayland.windowManager.hyprland.settings = {
    exec = [
      "fixbrightness"
    ];

    monitor = [
      "eDP-1, 2880x1920@60, auto, auto"
    ];
  };

  # Version of first install
  home-manager.users.samy.home.stateVersion = "24.11";
  system.stateVersion = "24.11";
}
