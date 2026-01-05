{
  config,
  pkgs,
  unstable,
  lib,
  ...
}:

let
  # Import host-specific options
  userOptions = import ./userOptions.nix;
  inherit (userOptions)
    username
    userHome
    gitName
    gitEmail
    gitDefaultBranch
    githubUser
    ;
in
{
  imports = [
    # Import the base module normally
    ../../modules/base.nix
  ];

  # Use _module.args to pass the data globally to all imported modules
  # 'options' will now be available as an argument named 'options' in base.nix
  _module.args.userOptions = userOptions;

  # Override base options with host-specific values
  home.username = username;
  home.homeDirectory = userHome;
  # macbookair-specific Fish configuration
  programs.fish = {
    shellAliases = {
      "hm-apply" = "home-manager switch --flake ${userHome}/code/home-manager-config#macbookair";
    };
  };
  # macbookair-specific packages
  home.packages = [
    # Add macbookair-specific packages here
    pkgs.nmap
    pkgs.opam
    pkgs.gemini-cli
    pkgs.python313Packages.wakeonlan
    pkgs.minio-client

    pkgs.nixos-anywhere
  ];
}
