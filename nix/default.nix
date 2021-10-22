{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {}
, gitrev ? null
}:
let
  sources = import ./sources.nix { inherit pkgs; }
    // sourcesOverride;
  bccNixMain = import sources.bcc-nix {};
  haskellNix = (import sources."haskell.nix" { inherit system sourcesOverride; }).nixpkgsArgs;
  # use our own nixpkgs if it exists in our sources,
  # otherwise use bccNix default nixpkgs.
  nixpkgs = if (sources ? nixpkgs)
    then (builtins.trace "Not using bcc default nixpkgs (use 'niv drop nixpkgs' to use default for better sharing)"
      sources.nixpkgs)
    else (builtins.trace "Using bcc default nixpkgs"
      bccNixMain.nixpkgs);

#TODO create haskell nix-repo ref below
  # for inclusion in pkgs:
  overlays =
    # Haskell.nix (https://github.com/bcc-coin/haskell.nix)
    haskellNix.overlays
    # haskell-nix.haskellLib.extra: some useful extra utility functions for haskell.nix
    ++ bccNixMain.overlays.haskell-nix-extra
    # bccNix: nix utilities and niv:
    ++ bccNixMain.overlays.bccNix
    # our own overlays:
    ++ [
      (pkgs: _: with pkgs; {
        # commonLib: mix pkgs.lib with bcc-nix utils and our own:
        commonLib = lib // bccNix
          // import ./util.nix { inherit haskell-nix; }
          # also expose our sources and overlays
          // { inherit overlays sources; };
      })
      # And, of course, our haskell-nix-ified cabal project:
      (import ./pkgs.nix)
    ];

  pkgs = import nixpkgs {
    inherit system crossSystem overlays;
    config = haskellNix.config // config;
  };

in pkgs
