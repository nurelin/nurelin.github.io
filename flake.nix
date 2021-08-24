{
  description = "blog.nurelin.eu flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    let
      pkgsFor = system: import nixpkgs {
        inherit system;
      };
    in {

    } // utils.lib.eachDefaultSystem (system:
      let pkgs = pkgsFor system;
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.zola ];
        };
      });
}

