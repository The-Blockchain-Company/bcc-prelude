# our packages overlay
pkgs: _: with pkgs; {
  bccPreludeHaskellPackages = import ./haskell.nix {
    inherit config
      lib
      stdenv
      haskell-nix
      buildPackages
      ;
  };

}
