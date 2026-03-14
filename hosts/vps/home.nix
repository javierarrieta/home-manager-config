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
    ../../modules/shell.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
