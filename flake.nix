{

  description = "Mixer Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages = {
          ocamlApp = pkgs.ocamlPackages.buildDunePackage rec {
            pname = "ocaml-app";
            version = "0.1.0";
            src = ./src/ocaml; # Path to your ocaml source code
            buildInputs = with pkgs; [
              opam
              ocamlPackages.core
              ocamlPackages.merlin
            ];
          };

          rustApp = pkgs.rustPlatform.buildRustPackage rec {
            pname = "rust-app";
            version = "0.1.0";
            src = ./src/rust; # Path to your rust source code
            cargoSha256 = "0000000000000000000000000000000000000000000000000000"; # Replace this with the correct sha256
          };

          haskellApp = pkgs.haskellPackages.callPackage ./haskell { }; # Assuming a default.nix exists in ./haskell path

          fsharpApp = pkgs.dotnetCorePackages.buildDotnetApp {
            pname = "fsharp-app";
            version = "0.1.0";
            src = ./src/fsharp; # Path to your F# source code
            projectFile = "fsharp-app.fsproj";
            nugetDeps = ./nuget-deps.nix; # Path to your nuget-deps.nix file
          };

          scalaApp = pkgs.scalaPackages.buildSbtPackage {
            pname = "scala-app";
            version = "0.1.0";
            src = ./src/scala; # Path to your Scala source code
          };

          nimApp = pkgs.nimble.buildNimPackage rec {
            pname = "nim-app";
            version = "0.1.0";
            src = ./src/nim; # Path to your Nim source code
          };

          zigApp = pkgs.zig.buildZigPackage rec {
            pname = "zig-app";
            version = "0.1.0";
            src = ./src/zig; # Path to your Zig source code
          };

          goApp = pkgs.buildGoModule rec {
            pname = "go-app";
            version = "0.1.0";
            src = ./src/go; # Path to your Go source code
            vendorSha256 = "0000000000000000000000000000000000000000000000000000"; # Replace this with the correct sha256
          };

          clojureApp = pkgs.lein.mkLeinPackage rec {
            pname = "clojure-app";
            version = "0.1.0";
            src = ./src/clojure; # Path to your Clojure source code
          };

          idrisApp = pkgs.idris2.buildIdrisPackage rec {
            pname = "idris-app";
            version = "0.1.0";
            src = ./src/idris; # Path to your Idris source code
          };

          elixirApp = pkgs.elixir.buildMix rec {
            pname = "elixir-app";
            version = "0.1.0";
            src = ./src/elixir; # Path to your Elixir source code
            mixEnv = "prod";
            buildInputs = [ pkgs.elixir pkgs.erlang ];
          };

        };

        devShells = {

          ocaml = pkgs.mkShell {
            buildInputs = with pkgs; [
              ocaml
              ocamlPackages.opam
              ocamlPackages.core
              ocamlPackages.merlin
            ];
          };

          rust = pkgs.mkShell {
            buildInputs = [ pkgs.rustc pkgs.cargo ];
          };

          haskell = pkgs.mkShell {
            buildInputs = [ pkgs.ghc pkgs.cabal-install ];
          };

          fsharp = pkgs.mkShell {
            buildInputs = [ pkgs.dotnetCorePackages.sdk_3_1 ];
          };

          scala = pkgs.mkShell {
            buildInputs = [ pkgs.scala pkgs.sbt ];
          };

          nim = pkgs.mkShell {
            buildInputs = [ pkgs.nim ];
          };

          zig = pkgs.mkShell {
            buildInputs = [ pkgs.zig ];
          };

          go = pkgs.mkShell {
            buildInputs = [ pkgs.go ];
          };

          clojure = pkgs.mkShell {
            buildInputs = [ pkgs.leiningen pkgs.clojure ];
          };

          idris = pkgs.mkShell {
            buildInputs = [ pkgs.idris2 ];
          };

          elixir = pkgs.mkShell {
            buildInputs = [ pkgs.elixir pkgs.erlang ];
          };

        };

        defaultPackage = packages.ocamlApp;
        defaultDevShell = devShells.ocaml;
      }
    );
}
