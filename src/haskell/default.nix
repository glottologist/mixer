{
  name = "mixer";
  buildInputs = [
    "ghc"
    "cabal-install"
  ];
  shellHook = ''
    cabal install --only-dependencies
    ghc -o mixer mixer.hs
  '';
}

