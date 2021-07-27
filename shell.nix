# bash shell config

{ config, lib, pkgs, ... }:

let
  shellAliases = {
      # git
      gitenv      = "eval \"$(ssh-agent -s)\"";
      gitchk      = "ssh-add ~/.ssh/id_ed25519";
      
      # general
      lxplus      = "ssh shoh@lxplus.cern.ch";
      nemacs      = "emacs -nw";
      xopen       = "nautilus";
      grep        = "grep --color=auto";
      ls          = "exa";
      reload      = "home-manager switch && source ~/.bashrc";
      
      # nix
      nixclean    = "nix-collect-garbage -d";
      nixoptimize = "nix-store --optimise";
      nixinstall  = "nix-env --query --installed";
      installnix  = "
                     curl -L https://nixos.org/nix/install | sh;
                     . /home/shoh/.nix-profile/etc/profile.d/nix.sh;
                     nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager;
                     nix-channel --update;
                     nix-shell '<home-manager>' -A install;
                   ";

      # docker
      #dockclean   = "docker image prune --force";
      
    };

in {

  # bash
  programs.bash = {
    inherit shellAliases;
    enable = true;
    
    # profile (any shell)
    profileExtra = ''
      source /usr/share/defaults/etc/profile
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
         . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
    
    # bashrc
    initExtra = ''
      source /usr/share/defaults/etc/profile
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
         . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi

      eval `dircolors -b "$HOME/.dir_colors/dircolors"`

      # Start up Docker daemon if not running
      if [ $(docker-machine status default) != "Running" ]; then
        docker-machine start default
      fi
    '';
    
    };
    
}