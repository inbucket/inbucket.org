{
  description = "jekyll environment for inbucket.org";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          serve = pkgs.writeShellScriptBin "serve" ''
            ${pkgs.jekyll}/bin/jekyll serve --watch
          '';
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              jekyll
              rubyPackages.jekyll-paginate
              serve
            ];

            shellHook = ''
              echo "Commands:"
              echo "  serve - runs jekyll w/ --watch"
            '';
          };
        }
      );
}