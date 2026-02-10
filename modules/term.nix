{
  config,
  pkgs,
  lib,
  userOptions,
  ...
}:
{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };
    enableGitIntegration = true;
  };
}
