{ pkgs, ... }:
let
  dependencies = with pkgs; [
    fd
    git
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
    (lib.lowPrio gotools) # goimports (lowPrio because 'modernize' collides with gopls)
    black
    clang-tools
    csharpier
    go-jsonnet # jsonnetfmt
    hurl
    isort
    nixfmt
    prettier
    prettierd
    ruff
    rustfmt
    shfmt
    stylua
    taplo
    xmlformat
    yamlfmt

    # Linters
    ansible-lint
    clippy
    djlint
    golangci-lint
    shellcheck
    tflint
    typos
    yamllint

    # LSP
    basedpyright
    bash-language-server
    cue
    gopls
    lua-language-server
    marksman
    nil
    roslyn-ls
    rust-analyzer
    templ
    terraform-ls
    tofu-ls
    typescript-language-server
    vscode-langservers-extracted # html, css, ...
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
