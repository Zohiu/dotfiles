{
  pkgs,
  globals,
  ...
}:

{
  home-manager.users.${globals.user} = {
    home.packages = (
      with pkgs;
      [
        jetbrains.pycharm-community-bin

        (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [
          "minecraft-development"
          "catppuccin-theme"
          "catppuccin-icons"
          "rainbow-brackets"
        ])
      ]
    );
  };
}
