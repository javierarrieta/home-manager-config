{
  config,
  pkgs,
  unstablePkgs,
  pkgsUnfree,
  unstablePkgsUnfree,
  lib,
  userOptions,
  hostname,
  ...
}:
{
  imports = [
    ../../modules/host-common.nix
    ../../modules/dev-tools.nix
    ../../modules/shell.nix
    ../../modules/python.nix
    ../../modules/k8s.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
