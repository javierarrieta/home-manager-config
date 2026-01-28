{
  config,
  pkgs,
  unstablePkgs,
  pkgsUnfree,
  unstablePkgsUnfree,
  lib,
  userOptions,
  ...
}:
let
  pythonVersion = lib.replaceStrings [ "." ] [ "" ] userOptions.pythonVersion;
in
{
  imports = [
    ../../modules/base.nix
  ];

  programs.fish = {
    shellAliases = {
      "hm-apply" = "home-manager switch --flake ${userOptions.userHome}/code/home-manager-config#macbookair";
      "sshk" = "ssh-add -D && ssh-add -t 18h";
    };
  };
  home.packages = [
    pkgs.nmap
    pkgs.opam
    pkgs.gemini-cli
    pkgs."python${pythonVersion}Packages".wakeonlan
    pkgs.minio-client
    unstablePkgs.opencode
    pkgs.nixos-anywhere
  ];
}
