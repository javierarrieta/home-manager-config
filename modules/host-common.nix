{ config, lib, hostname, ... }:
let
  userOptions = import ../hosts/${hostname}/userOptions.nix;
in
{
  _module.args.userOptions = userOptions;

  home.username = userOptions.username;
  home.homeDirectory = userOptions.userHome;
}
