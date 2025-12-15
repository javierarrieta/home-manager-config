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

  # oracle-specific packages
  home.packages = [
    # Add oracle-specific packages here
    pkgs.vscode
    pkgs.llama-cpp
    pkgs.kubectl
    pkgs.kubectx
  ];

  # oracle-specific Fish configuration
  programs.fish = {
    # oracle-specific abbreviations
    shellAbbrs = {
      "k9st" = {
        expansion = "k9s --namespace stream-app --context Stage/OC1/%";
        position = "command";
        setCursor = true;
      };
      "k9pr" = {
        expansion = "k9s --namespace stream-app --context Prod/OC%";
        position = "command";
        setCursor = true;
      };

      "pf-grafana" = "echo 'Open grafana at http://localhost:9091/' && kubectl port-forward service/grafana 9091:3000 -n octo-system --context";
      "pf-prom" = "echo 'Open prometheus at http://localhost:9093/' && kubectl port-forward service/prometheus-k8s 9093:9090 -n octo-system --context";
      "pf-akhq" = "echo 'Open akhq at http://localhost:9092/' && kubectl port-forward service/akhq 9092:80 -n kafka --context";

      "akhq-pass" = "kubectl get secret -n kafka akhq-admin-user-creds -o json | jq '.data.ociVaultContent' | tr -d '\"' | base64 -D | pbcopy";
 
    };
  };

}