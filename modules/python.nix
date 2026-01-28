{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    python313
    pipenv
    python313Packages.virtualenv
    python313Packages.uv
    python313Packages.pylint
    python313Packages.oci
  ];

  programs.pyenv = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
