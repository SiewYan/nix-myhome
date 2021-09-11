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
      reload      = "cd $HOME/Install/nixfiles && git pull; home-manager switch && source ~/.bashrc";
      
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
      #useroot     = "if [ -e $HOME/Installs/ROOT/install/bin/thisroot.sh ]; then source /home/shoh/Installs/ROOT/install/bin/thisroot.sh; fi";
      useroot     = "nix-shell $HOME/Install/nixfiles/shells/root-6p18.nix";

      # conda
      #conda config --add --env channels conda-forge
      #conda create -n myrootenv python=3.7 root -c conda-forge
      #conda env export --name ENVNAME > envname.yml
      #conda env create --file envname.yml

      useconda     = "
            	      __conda_setup=\"$('/home/shoh/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"
      		      if [ $? -eq 0 ]; then
         	      	 eval \"$__conda_setup\"
      		      else
			 if [ -f \"/home/shoh/anaconda3/etc/profile.d/conda.sh\" ]; then
            		    . \"/home/shoh/anaconda3/etc/profile.d/conda.sh\"
         		 else
			    export PATH=\"/home/shoh/anaconda3/bin:$PATH\"
         		 fi
      		      fi
      		      unset __conda_setup
      		    ";
      condaup      = "conda update conda";
      condalist    = "conda env list";
      activate     = "conda activate";
      deactivate   = "conda deactivate";
      
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
    '';
    
    # bashrc
    initExtra = ''
      
      # source the backup bashrc (if any)
      if [ -e $HOME/.bashrc.bak ]; then
      	 source $HOME/.bashrc.bak;
      fi

      # system-wide ROOT
      #if [ -e $HOME/Installs/ROOT/install/bin/thisroot.sh ]; then
      #	 source /home/shoh/Installs/ROOT/install/bin/thisroot.sh;
      #fi
      
      eval `dircolors -b "$HOME/.dir_colors/dircolors"`

      # To temporarily allow unfree packages
      export NIXPKGS_ALLOW_UNFREE=1

      # kube
      #export KUBECONFIG=$HOME/.kube/k3s/config
      
    '';
    
    };
    
}
