{ pkgs, ... }:
let
  dependencies = with pkgs; [
    fd
    gcc
    git
    tree-sitter
    ripgrep
  ];

  linuxDependencies = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
  ];

  tools = with pkgs; [
    # Dependencies
    scooter
    silicon
    ghostscript
    mermaid-cli
    plantuml
    graphviz # plantuml
    jre # plantuml-previewer
    imagemagick
    nodejs

    # Formatters
    clang-tools
    csharpier
    gersemi
    gofumpt
    gotools
    nixfmt
    prettier
    prettierd
    ruff
    rustfmt
    shfmt
    stylua
    tex-fmt

    # Linters
    clippy # rust-analyzer check
    shellcheck # bash-language-server

    # LSP
    angular-language-server
    basedpyright
    bash-language-server
    dockerfile-language-server
    gopls
    hyprls
    lua-language-server
    marksman
    neocmakelsp
    nixd
    roslyn-ls
    rust-analyzer
    sqruff
    taplo
    templ
    texlab
    vscode-langservers-extracted
    vtsls
    vue-language-server
    yaml-language-server
  ];
in
{
  packages = dependencies ++ tools ++ linuxDependencies;

  corePackages = dependencies ++ linuxDependencies;

  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      # jsregexp # required by luasnip
      luarocks
      magick
    ];

  coreLuaPackages =
    ps: with ps; [
      luarocks
    ];

  # Extra python packages
  extraPython3Packages = _: [ ];
}
