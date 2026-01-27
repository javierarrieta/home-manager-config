{
  description = "Modular Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
    };
    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, home-manager, unstable, flake-utils, ... }:
    let
      mkExtraArgs = system: {
        unstablePkgs = import unstable {
          inherit system;
          config.allowUnfree = false;
        };
        pkgsUnfree = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unstablePkgsUnfree = import unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = false;
          };
        };
      in
      {
        packages = {
          default = home-manager.packages.${system}.home-manager;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            home-manager
            nixpkgs-fmt
          ];
        };
      }) // {
        # Define configurations for different hosts
        homeConfigurations."oracle" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config = {
              allowUnfree = false;
            };
          };
          modules = [ ./hosts/oracle/home.nix ];
          extraSpecialArgs = mkExtraArgs "aarch64-darwin";
        };
        
        homeConfigurations."macbookair" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config = {
              allowUnfree = false;
            };
          };
          modules = [ ./hosts/macbookair/home.nix ];
          extraSpecialArgs = mkExtraArgs "aarch64-darwin";
        };
      };
}