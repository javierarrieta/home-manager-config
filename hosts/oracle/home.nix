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
  # 'userOptions' will now be available as an argument named 'userOptions' in base.nix
  _module.args.userOptions = userOptions;

  # Override base options with host-specific values
  home.username = username;
  home.homeDirectory = userHome;

  # oracle-specific packages
  home.packages = [
    # Add oracle-specific packages here
    pkgs.kcl
  ];

  # oracle-specific Fish configuration
  programs.fish = {
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

      "pf-grafana" =
        "echo 'Open grafana at http://localhost:9091/' && kubectl port-forward service/grafana 9091:3000 -n octo-system --context";
      "pf-prom" =
        "echo 'Open prometheus at http://localhost:9093/' && kubectl port-forward service/prometheus-k8s 9093:9090 -n octo-system --context";
      "pf-akhq" =
        "echo 'Open akhq at http://localhost:9092/' && kubectl port-forward service/akhq 9092:80 -n kafka --context";
      "pf-cruisecontrol" =
        "echo 'Open Cruise Control at https://localhost:9090/' && kubectl port-forward service/scs-data-mesh-prod-cruise-control 9090:9090 -n kafka --context";
      "akhq-pass" =
        "kubectl get secret -n kafka akhq-admin-user-creds -o json | jq '.data.ociVaultContent' | tr -d '\"' | base64 -D | pbcopy";

    };
    shellAliases = {
      "hm-apply" = "home-manager switch --flake ${userHome}/code/home-manager-config#oracle";
      "fashion-token" = "z ${userHome}/code/fashion_token && cargo run --release ; z -";
      "ministral-reasoning" =
        "llama-server --model ${userHome}/llm/models/unsloth_Ministral-3-14B-Reasoning-2512-GGUF_Ministral-3-14B-Reasoning-2512-Q4_K_M.gguf --jinja -ngl 99 --threads -1 --ctx-size 32684 --temp 0.6 --top-p 0.95   --offline";
      "ministral-instruct" =
        "llama-server --model $HOME/llm/models/unsloth_Ministral-3-3B-Instruct-2512-GGUF_Ministral-3-3B-Instruct-2512-UD-Q4_K_XL.gguf --jinja -ngl 99 --threads -1 --ctx-size 32684 --temp 0.15 --port 8081 --offline --metrics";
    };
  };

  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      saoudrizwan.claude-dev
    ];
  };

}
