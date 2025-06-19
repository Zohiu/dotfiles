{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Zohiu";
    userEmail = "mail@zohiu.de";
    extraConfig = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      commit.gpgsign = true;
      user.signingkey = "F93EC485BC2ED258";
      init.defaultBranch = "main";
    };
  };

  home.packages = [
    pkgs.github-backup
  ];
}
