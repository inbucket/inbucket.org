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

        scripts.serve = pkgs.writeShellScriptBin "serve" ''
          cd "$(git rev-parse --show-toplevel)"
          jekyll serve --host 0.0.0.0 --watch
        '';

        # TODO Replace with Jekyll + Lustre GHA
        scripts.lustre-build = pkgs.writeShellScriptBin "lustre-build" ''
          set -xeo pipefail

          src=lustre-configurator
          target=configurator

          cd "$(git rev-parse --show-toplevel)"
          test -d $src || (echo "ERROR: dir $src does not exist"; exit 5)

          pushd $src
          gleam clean
          gleam run -m lustre/dev build configurator
          popd

          sed -i 's|/configurator\.js|/configurator/configurator.js|' $target/index.html
        '';
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            (jekyll.override { withOptionalDependencies = true; })
            scripts.serve
            scripts.lustre-build

            # Gleam
            beam27Packages.erlang
            beam27Packages.rebar3
            gleam
            inotify-tools
          ];

          shellHook = ''
            echo
            echo "Commands:"
            echo "  serve - runs jekyll w/ --watch"
            echo "  lustre-build - builds the Lustre configurator"
            echo
          '';
        };
      }
    );
}
