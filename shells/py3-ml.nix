# https://josephsdavid.github.io/nix.html

let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    name = "ML";
    buildInputs = with pkgs; [
    # basic python dependencies
      python37
      python37Packages.jupyter
      python37Packages.matplotlib
      python37Packages.numpy
      python37Packages.pandas
      python37Packages.scikitlearn
      python37Packages.scipy
    # a couple of deep learning libraries
      #python37Packages.tensorflow # note if you get rid of WithCuda then you will not be using Cuda
      #python37Packages.Keras
      #python37Packages.pytorch

    # Lets assume we also want to use R, maybe to compare sklearn and R models
      #R
      #rPackages.mlr
      #rPackages.data_table # "_" replaces "."
      #rPackages.ggplot2
    ];
   shellHook = ''
      python3 -m ipykernel install --user --name=python3
      '';
}