{ pkgs, globals, ... }:
let
  model = "TabbyML/StarCoder2-3B";
  chat_model = "TabbyML/CodeQwen-7B-Chat";
  port = "11029";
in
{
  # Tabby AI code completion
  systemd.user.services.tabby = {
    description = "Self-hosted AI coding assistant";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      WorkingDirectory = "/home/${globals.user}/.tabby";
      StateDirectory = "tabby";        # systemd will create ~/.local/state/tabby
      ConfigurationDirectory = "tabby"; # systemd will create ~/.config/tabby
      Environment = ''
        LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
        PATH=${pkgs.coreutils}/bin:${pkgs.bash}/bin:/run/current-system/sw/bin
        TABBY_DISABLE_USAGE_COLLECTION=1
        TABBY_ROOT="/home/${globals.user}/.tabby"
        TZDIR=${pkgs.tzdata}/share/zoneinfo
      '';
      ExecStart = "${pkgs.tabby}/bin/tabby serve --model ${model} --chat-model ${chat_model} --port ${port} --host 127.0.0.1";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  home-manager.users.${globals.user}.home.packages = with pkgs; [
    (writeShellScriptBin "tabby" ''
      #!${pkgs.bash}/bin/bash
      SERVICE="tabby.service"

      case "$1" in
        start)
          echo "Starting Tabby service..."
          systemctl --user start $SERVICE
          ;;
        stop)
          echo "Stopping Tabby service..."
          systemctl --user stop $SERVICE
          ;;
        status)
          systemctl --user status $SERVICE
          ;;
        *)
          echo "Usage: $0 {start|stop|status}"
          exit 1
          ;;
      esac
    '')
  ];
}
