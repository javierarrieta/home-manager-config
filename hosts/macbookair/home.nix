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
let
  pythonVersion = lib.replaceStrings [ "." ] [ "" ] userOptions.pythonVersion;
in
{
  imports = [
    ../../modules/base.nix
  ];

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${userOptions.userHome}/.config/sops/age/keys.txt";
  };

  programs.fish = {
    shellAliases = {
      "sshk" = "ssh-add -D && ssh-add -t 18h";
    };

  };
  home.packages = [
    pkgs.nmap
    pkgs.opam
    pkgs.gemini-cli
    pkgs."python${pythonVersion}Packages".wakeonlan
    pkgs.minio-client
    pkgs.wp-cli
    pkgs.bun

    unstablePkgs.opencode
  ];
}
