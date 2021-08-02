# https://josephsdavid.github.io/nix.html
# https://github.com/det-lab/root-nix/blob/master/root-local/default.nix
{
  pkgs ? import <nixpkgs> {}
}:
with pkgs;

let
  inherit stdenv lib fetchurl makeWrapper cmake ftgl gl2ps glew gsl llvm_5
  libX11 libXpm libXft libXext libGLU libGL libxml2 lz4 xz pcre pkg-config python xxHash zlib zstd
  libAfterImage giflib libjpeg libtiff libpng;

  myroot = stdenv.mkDerivation rec {
    pname = "root";
    version = "6.18.04";
    noSplash = false;
        
    src = fetchurl {
      url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
      sha256 = "196ghma6g5a7sqz52wyjkgvmh4hj4vqwppm0zwdypy33hgy8anii";
    };

    nativeBuildInputs = with pkgs; [ makeWrapper cmake pkg-config ];
    
    buildInputs = with pkgs; [ ftgl gl2ps glew pcre zlib zstd llvm_5 libxml2 lz4 ninja
      xz gsl xxHash libAfterImage giflib libjpeg libtiff libpng python.pkgs.numpy
      ]
      ++ lib.optionals (!stdenv.isDarwin) [ xlibs.libX11 xlibs.libXpm xlibs.libXft xlibs.libXext libGLU libGL ]
      ;

    #patches = [
    #  ./scripts/sw_vers.patch
    #];
      
    preConfigure = ''
      rm -rf builtins/*
      substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
        --replace 'set(lcgpackages ' '#set(lcgpackages '
	
      patchShebangs build/unix/
    '' + lib.optionalString noSplash ''
      substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
    ''
    ;
    
    cmakeFlags = [
      "-Drpath=ON"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      #"-DCMAKE_GENERATOR=Ninja"
      "-Dalien=OFF"
      "-Dbonjour=OFF"
      "-Dbuiltin_llvm=OFF"
      "-Dcastor=OFF"
      "-Dchirp=OFF"
      "-Dclad=OFF"
      "-Ddavix=OFF"
      "-Ddcache=OFF"
      "-Dfail-on-missing=ON"
      "-Dfftw3=OFF"
      "-Dfitsio=OFF"
      "-Dfortran=OFF"
      "-Dimt=OFF"
      "-Dgfal=OFF"
      "-Dgviz=OFF"
      "-Dhdfs=OFF"
      "-Dkrb5=OFF"
      "-Dldap=OFF"
      "-Dmonalisa=OFF"
      "-Dmysql=OFF"
      "-Dodbc=OFF"
      "-Dopengl=ON"
      "-Doracle=OFF"
      "-Dpgsql=OFF"
      "-Dpythia6=OFF"
      "-Dpythia8=OFF"
      "-Drfio=OFF"
      "-Dsqlite=OFF"
      "-Dssl=OFF"
      "-Dvdt=OFF"
      "-Dxml=ON"
      "-Dxrootd=OFF"
    ]
    ++ lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
    ;

    enableParallelBuilding = true;
    
    postInstall = ''
      for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
        wrapProgram "$out/bin/$prog" \
          --prefix PYTHONPATH : "$out/lib"
      done
    '';

    setupHook = ./scripts/setup-hook.sh;
    
  };
in
  pkgs.mkShell {
    inherit myroot;
    name = "ROOTmyroot.version";
    buildInputs = with pkgs; [ myroot ];
    
    setupHook = ''
    echo "welcom to ROOT version myroot.version";
    '';
  }