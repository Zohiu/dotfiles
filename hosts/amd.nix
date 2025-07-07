{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Hyprland mesa
  pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in

{
  # AMD graphics
  hardware.graphics = {
    enable = true;
    package = pkgs-hypr.mesa;
    extraPackages = with pkgs; [
      libva
      libvdpau-va-gl
      vulkan-loader
      vulkan-validation-layers
      # amdvlk
      mesa.opencl
      rocmPackages.clr.icd
    ];
  };
}
