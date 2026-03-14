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
}
