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
  ];
}
