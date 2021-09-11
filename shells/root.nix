let
  pkgs = import <nixpkgs> {};
  #imports = [ ./rootv/root-6p18.nix ];
in
  pkgs.mkShell {
    name = "ROOT";
    #buildInputs = with pkgs; [
    nativeBuildInputs = with pkgs; [
    # basic python dependencies
      python37
      python37Packages.numpy
      python37Packages.scipy
    ];
   shellHook = ''
      '';
}
