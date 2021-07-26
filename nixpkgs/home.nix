{ config, lib, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "shoh";
  home.homeDirectory = "/home/shoh";

  # Raw configuration files
  home.file.".vimrc".source = ../vimrc;
  home.file.".dir_colors/dircolors".source = ../dircolors;

  # list of my essential packages
  home.packages = with pkgs; [ git emacs htop root ];

  programs.bash = {
    enable = true;
    # profile (any shell)
    profileExtra = ''
      source /usr/share/defaults/etc/profile
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
      	 . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
    # bash specific
    initExtra = ''
      source /usr/share/defaults/etc/profile
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
         . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
      
      eval `dircolors -b "$HOME/.dir_colors/dircolors"`
    '';
    shellAliases = {
      # git
      gitenv      = "eval \"$(ssh-agent -s)\"";
      gitchk      = "ssh-add ~/.ssh/id_ed25519";
      # general
      lxplus      = "ssh shoh@lxplus.cern.ch";
      nemacs      = "emacs -nw";
      xopen       = "nautilus";
      # nix
      nixclean    = "nix-collect-garbage -d";
      nixoptimize = "nix-store --optimise";
      installnix  = "
                     curl -L https://nixos.org/nix/install | sh;
                     . /home/shoh/.nix-profile/etc/profile.d/nix.sh;
                     nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager;
                     nix-channel --update;
                     nix-shell '<home-manager>' -A install;
		     ";
    };
  };

  # git
  programs.git = {
    enable = true;
    userName = "SiewYan";
    userEmail = "siew.yan.hoh@cern.ch";
    aliases = {
      st = "status";
    };
  };

  home.stateVersion = "21.05";
}
