{ config, pkgs, lib, ... }:

let
  # Import host-specific options
  options = import ./options.nix;
  inherit (options) username userHome gitName gitEmail gitDefaultBranch githubUser;

  # Base module
  baseModule = import ../../modules/base.nix;

in
{
  imports = [ baseModule ];

  # Override base options with host-specific values
  home.username = username;
  home.homeDirectory = userHome;

  # macbookair-specific packages
  home.packages = [
    # Add macbookair-specific packages here
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubectx
    pkgs.docker
    pkgs.docker-compose
    pkgs.vscode
    pkgs.postgresql
    pkgs.gnome.gnome-system-monitor
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

  # macbookair-specific aliases
  programs.fish.shellAliases = {
    "k9s" = "k9s --namespace stream-app --context Stage/OC1/";
    "kubectl" = "kubectl --namespace stream-app --context Stage/OC1/";
  };
}