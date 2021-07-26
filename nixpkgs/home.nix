{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "shoh";
  home.homeDirectory = "/home/shoh";

  # list of my essential packages
  home.packages = [
  		pkgs.git
  		pkgs.emacs
		pkgs.htop
  		pkgs.tmux
		];

  home.stateVersion = "21.05";
}
