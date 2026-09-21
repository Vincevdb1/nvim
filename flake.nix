{
  description = "Vincevdb1 neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=c581273b8d5bdf1c6ce7e0a54da9841e6a763913";
    # Tracks latest nixpkgs for CLI tools, formatters, linters and LSPs,
    # kept separate so they can update without bumping the neovim pin.
    nixpkgs-tools.url = "github:NixOS/nixpkgs";

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

      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # Override XDG_CONFIG_HOME for nvim only; exporting it from the shellHook
          # would leak it into the whole session and break fish, git, gh, ...
          devNvim = pkgs.writeShellScriptBin "nvim" ''
            if [ -n "''${NVIM_DEV_CONFIG_HOME:-}" ]; then
              export NVIM_HOST_XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
              export XDG_CONFIG_HOME="$NVIM_DEV_CONFIG_HOME"
              export NVIM_DEV_SHELL=1
            fi
            exec ${self.packages.${system}.vanilla}/bin/nvim "$@"
          '';
        in
        {
          # `nix develop`: nvim in this shell reads its config live from ./nvim,
          # so edits are immediately reflected and already sit in this repo.
          default = pkgs.mkShellNoCC {
            name = "nvim-config";
            packages = [ devNvim ];
            shellHook = ''
              root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
              if [ ! -d "$root/nvim" ]; then
                echo "nvim devshell: no $root/nvim directory, not linking config" >&2
              else
                confdir="$root/.direnv/nvim-config"
                mkdir -p "$confdir"
                ln -sfn "$root/nvim" "$confdir/nvim-nix"
                export NVIM_DEV_CONFIG_HOME="$confdir"
              fi
            '';
          };
        }
      );

      # for `nix fmt`
      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
