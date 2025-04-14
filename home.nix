{ username, hostname, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  imports = [
    ./zsh.nix # <- hostname
  ];

  programs.home-manager.enable = true;
}
