{
  inputs,
  globals,
  ...
}:

{
  # home-manager.users.${globals.user} = {
  #   imports = [
  #     "${inputs.shadow-nix}/import/home-manager.nix"
  #   ];

  #   programs.shadow-client = {
  #     enable = true;
  #     channel = "prod";
  #   };
  # };
}
