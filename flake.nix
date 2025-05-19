{
  description = "jekyll environment for inbucket.org";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        serve = pkgs.writeShellScriptBin "serve" ''
          jekyll serve --watch
        '';
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            (jekyll.override { withOptionalDependencies = true; })
            serve

            # Gleam
            erlang_27
            gleam
            inotify-tools
            rebar3
          ];

          shellHook = ''
            echo "Commands:"
            echo "  serve - runs jekyll w/ --watch"
          '';
        };
      }
    );
}
