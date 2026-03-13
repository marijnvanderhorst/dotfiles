{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
      export DYLD_FALLBACK_LIBRARY_PATH="${
        pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.file
        ]
      }"
    '';
  };
}
