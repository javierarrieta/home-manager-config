{ config, pkgs, lib, ... }:

let
  # Import host-specific options
  userOptions = import ./userOptions.nix;
  inherit (userOptions) username userHome gitName gitEmail gitDefaultBranch githubUser;
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

  # macbookair-specific packages
  home.packages = [
    # Add macbookair-specific packages here
    pkgs.nmap
    pkgs.vscode
    pkgs.opam
    pkgs.gemini-cli
    pkgs.python313Packages.wakeonlan
  ];

  # macbookair-specific Fish configuration
  programs.fish = {
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
      
      # Activate virtual environment if it exists
      test -e ~/.venv/default/bin/activate.fish || venv ~/.venv/default
      source ~/.venv/default/bin/activate.fish
      
      starship init fish | source
    '';
  };
}