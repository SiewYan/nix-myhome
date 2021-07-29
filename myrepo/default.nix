{
  pkgs ? import <nixpkgs> {}
  #pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/b58ada326aa612ea1e2fb9a53d550999e94f1985.tar.gz) {}
  #pkgs ? import (fetchTarball  https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz) {}
}:

with pkgs;

let
  packages = rec {
    root-5 = callPackage ./pkgs/root/root-5.nix {};
    root-6 = callPackage ./pkgs/root/root-6.nix {};
    
    #chord = callPackage ./pkgs/chord {};    
    #chord_custom_sg = callPackage ./pkgs/chord { simgrid = custom_simgrid; };
    #custom_simgrid = callPackage ./pkgs/simgrid/custom.nix {};

    inherit pkgs; # This lets callers use the nixpkgs version defined in this file.
  };
in
  packages