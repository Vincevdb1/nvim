return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/home/username/dotfiles/nix").nixosConfigurations.nixos.options',
        },
        home_manager = {
          expr = '(builtins.getFlake "/home/username/dotfiles/nix").nixosConfigurations.nixos.options.home-manager.users.username'
        },
      },
    },
  },
}
