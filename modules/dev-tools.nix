{
  config,
  pkgs,
  unstablePkgs,
  pkgsUnfree,
  unstablePkgsUnfree,
  ...
}:
{
  home.packages = with pkgs; [
    htop
    nvtopPackages.apple
    git
    curl
    wget
    tmux
    btop
    ripgrep
    yq
    jq
    rustup
    fzf
    bash
    zsh
    bat
    lsd
    difftastic
    dyff
    age
    sops
    neofetch
    nixfmt
    kubernetes-helm
    scala-cli
    pstree
    nodejs_24
    pkgsUnfree.gimp2-with-plugins

    haskell.compiler.ghc98
    haskell-language-server
    haskellPackages.cabal-install

    ocaml
    dune_3

    unstablePkgs.esphome
    unstablePkgs.platformio
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
