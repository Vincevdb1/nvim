{
  description = "Vincevdb1 neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=c581273b8d5bdf1c6ce7e0a54da9841e6a763913";

    systems.url = "github:nix-systems/default";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins built from source outside of nixpkgs
    # vim-varnish.url = "github:varnishcache-friends/vim-varnish";
    # vim-varnish.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      packages = eachSystem (system: {
        # Default package, neovim with the config embedded in the store
        default = import ./nix/neovim.nix { inherit inputs system; };
        # Alternative, uses the config at ~/.config/nvim-nix
        vanilla = import ./nix/neovim.nix {
          inherit inputs system;
          with-config = false;
        };
      });

      devShells = eachSystem (system: {
        # `nix develop`: nvim in this shell reads its config live from ./nvim,
        # so edits are immediately reflected and already sit in this repo.
        default = nixpkgs.legacyPackages.${system}.mkShellNoCC {
          name = "nvim-config";
          packages = [ self.packages.${system}.vanilla ];
          shellHook = ''
            root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
            if [ ! -d "$root/nvim" ]; then
              echo "nvim devshell: no $root/nvim directory, not linking config" >&2
            else
              confdir="$root/.direnv/nvim-config"
              mkdir -p "$confdir"
              ln -sfn "$root/nvim" "$confdir/nvim-nix"
              export XDG_CONFIG_HOME="$confdir"
              export NVIM_DEV_SHELL=1
            fi
          '';
        };
      });

      # for `nix fmt`
      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
