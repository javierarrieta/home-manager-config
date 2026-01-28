{
  config,
  pkgs,
  unstablePkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kubectl
    kubectx
    k9s
    unstablePkgs.llama-cpp
  ];
}
