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
      nixupdate   = "nix-channel --update nixpkgs";
      installnix  = "
                     curl -L https://nixos.org/nix/install | sh;
                     . /home/shoh/.nix-profile/etc/profile.d/nix.sh;
                     nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager;
                     nix-channel --update;
                     nix-shell '<home-manager>' -A install;
                   ";
      usenix      = ". $HOME/.nix-profile/etc/profile.d/nix.sh; echo Nix appended to PATH; echo Once edited nix file, use reload";

      # docker
      #dockclean  = "docker image prune --force";

      # root
      useroot     = "if [ -e $HOME/Installs/ROOT/install/bin/thisroot.sh ]; then source /home/shoh/Installs/ROOT/install/bin/thisroot.sh; fi";

      # pi cluster
      pishutdown  = "for ip in master node1 node2 node3; do ssh pi@$ip.local 'sudo poweroff'; done";
      # flatpak
      flatup      = "flatpak update";
    };

in {

  # bash
  programs.bash = {
    inherit shellAliases;
    enable = true;
    
    # profile (any shell)
    profileExtra = ''
      # ~/.profile: executed by the command interpreter for login shells.                                                                                                                           
      # This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login                                                                                                                       
      # exists.                                                                                                                                                                                     
      # see /usr/share/doc/bash/examples/startup-files for examples.                                                                                                                                
      # the files are located in the bash-doc package.                                                                                                                                              

      # the default umask is set in /etc/profile; for setting the umask                                                                                                                             
      # for ssh logins, install and configure the libpam-umask package.                                                                                                                             
      #umask 022                                                                                                                                                                                    

      # if running bash                                                                                                                                                                             
      if [ -n "$BASH_VERSION" ]; then
           # include .bashrc if it exists                                                                                                                                                            
          if [ -f "$HOME/.bashrc" ]; then
               . "$HOME/.bashrc"
          fi
      fi

      # set PATH so it includes user's private bin if it exists                                                                                                                                     
      if [ -d "$HOME/bin" ] ; then
          PATH="$HOME/bin:$PATH"
      fi

      # set PATH so it includes user's private bin if it exists                                                                                                                                     
      if [ -d "$HOME/.local/bin" ] ; then
           PATH="$HOME/.local/bin:$PATH"
      fi
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
         . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
    
    # bashrc
    initExtra = ''
      source /usr/share/defaults/etc/profile
      
      # source the backup bashrc (if any)
      if [ -e $HOME/.bashrc.bak ]; then
      	 source $HOME/.bashrc.bak;
      fi

      # system-wide ROOT
      #if [ -e $HOME/Installs/ROOT/install/bin/thisroot.sh ]; then
      #	 source /home/shoh/Installs/ROOT/install/bin/thisroot.sh;
      #fi
      
      #if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
      #   . $HOME/.nix-profile/etc/profile.d/nix.sh;
      #fi

      eval `dircolors -b "$HOME/.dir_colors/dircolors"`

      # To temporarily allow unfree packages
      export NIXPKGS_ALLOW_UNFREE=1

      # kube
      export KUBECONFIG=$HOME/.kube/k3s/config
    '';
    
    };
    
}
