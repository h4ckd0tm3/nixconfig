{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-cask-fonts = {
      url = "github:homebrew/homebrew-cask-fonts";
      flake = false;
    };
    homebrew-fkratz = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    homebrew-koekeishiya = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };
  };

  outputs = inputs@{ self, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, homebrew-cask-fonts, homebrew-fkratz, homebrew-koekeishiya, home-manager, nixpkgs, flake-parts, nixos-flake, ...}:
    let
      user = "marcel.schnideritsch";
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (darwinSystems) f;
    in
    {
      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
                  "FelixKratz/formulae" = homebrew-fkratz;
                  "koekeishiya/formulae" = homebrew-koekeishiya;
                };
                mutableTaps = true;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
      );
    };
}
