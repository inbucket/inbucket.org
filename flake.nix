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
          jekyll serve --watch
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
          rm -rf priv
          gleam run -m lustre/dev build app --minify
          popd

          test -d $target && rm -rf $target
          mkdir $target
          cp -r $src/priv/* $target

          cp $src/index.html $target/index.html
          sed -i 's|priv/static/configurator\.mjs|configurator/static/configurator.min.mjs|' $target/index.html
        '';
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            (jekyll.override { withOptionalDependencies = true; })
            scripts.serve
            scripts.lustre-build

            # Gleam
            erlang_27
            gleam
            inotify-tools
            rebar3
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
