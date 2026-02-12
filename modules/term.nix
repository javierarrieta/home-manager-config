{
  config,
  pkgs,
  lib,
  userOptions,
  ...
}:
{
  home.packages = with pkgs.nerd-fonts; [
    fira-code
    zed-mono
    iosevka
    jetbrains-mono
  ];

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };
    font = {
      name = "FiraCode-Retina";
      size = 10;
    };
    enableGitIntegration = true;
  };
}
