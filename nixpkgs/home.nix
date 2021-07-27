{ config, lib, pkgs, ... }:

let
  imports = [ ./shell.nix ./git.nix ];

  # Handly shell command to view the dependency tree of Nix packages
  depends = pkgs.writeScriptBin "depends" ''
    dep=$1
    nix-store --query --requisites $(which $dep)
  '';

  git-hash = pkgs.writeScriptBin "git-hash" ''
    nix-prefetch-url --unpack https://github.com/$1/$2/archive/$3.tar.gz
  '';

  wo = pkgs.writeScriptBin "wo" ''
    readlink $(which $1)
  '';

  run = pkgs.writeScriptBin "run" ''
    nix-shell --pure --run "$@"
  '';

in {
  inherit imports;

  # enable home manager
  programs.home-manager.enable = true;

  # home.username = "$USER";
  # home.homeDirectory = "/home/$USER";
  # home.sessionVariables.EDITOR = "emacs";

  home = {
    username = "$USER";
    homeDirectory = "/home/$USER";
    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  # Miscellaneous packages
  home.packages = with pkgs; [ git emacs htop root python ];

  # Raw configuration files
  home.file.".vimrc".source = ../vimrc;
  home.file.".dir_colors/dircolors".source = ../dircolors;

  home.stateVersion = "21.05";
}
