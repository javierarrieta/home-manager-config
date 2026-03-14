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
    nixfmt-tree
    kubernetes-helm
    pstree
    nodejs_24

    hugo
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
}
