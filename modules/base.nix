{
  config,
  pkgs,
  lib,
  userOptions,
  ...
}:
{
  home.stateVersion = "25.05";

  imports = [
    ./dev-tools.nix
    ./shell.nix
    ./python.nix
    ./k8s.nix
    ./editors.nix
  ];

  home.packages = with pkgs; [ nixd ];

  programs.home-manager.enable = true;
}
