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

  # oracle-specific packages
  home.packages = [
    # Add oracle-specific packages here
    pkgs.fishPlugins.tide
    pkgs.fishPlugins.fzf
    pkgs.orbstack
    pkgs.vscode
    pkgs.llama-cpp
    pkgs.postgresql
  ];

  # oracle-specific Fish configuration
  programs.fish = {
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
      
      # Activate virtual environment if it exists
      test -e ~/.venv/default/bin/activate.fish || venv ~/.venv/default
      source ~/.venv/default/bin/activate.fish
      
      starship init fish | source
    '';
    
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide;
      }
    ];
  };

  # oracle-specific aliases
  programs.fish.shellAliases = {
    "k9st" = "k9s --namespace stream-app --context Stage/OC1/";
    "k9pr" = "k9s --namespace stream-app --context Prod/OC";
    "pf-grafana" = "echo 'Open grafana at http://localhost:9091/' && kubectl port-forward service/grafana 9091:3000 -n octo-system --context";
    "pf-prom" = "echo 'Open prometheus at http://localhost:9093/' && kubectl port-forward service/prometheus-k8s 9093:9090 -n octo-system --context";
    "pf-akhq" = "echo 'Open akhq at http://localhost:9092/' && kubectl port-forward service/akhq 9092:80 -n kafka --context";
  };
}