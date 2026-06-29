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
    llama-cpp
  ];
}
