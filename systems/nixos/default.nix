{ inputs, ... }:
let
  system = "x86_64-linux";
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  bumblebee = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs-stable
        system
        ;
    };
    modules = [
      ./configuration.nix
      ./bumblebee
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs pkgs-stable;
        };
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
        ];
        home-manager.backupFileExtension = "backup";
        home-manager.users.morgan = {
          imports = [
            ../../home.nix
            ./bumblebee/home.nix
          ];
        };
      }
    ];
  };
  everest = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs-stable
        system
        ;
    };
    modules = [
      ./configuration.nix
      ./everest
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs pkgs-stable;
        };
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
        ];
        home-manager.backupFileExtension = "backup";
        home-manager.users.morganf = {
          imports = [
            ../../home.nix
            ./everest/home.nix
          ];
        };
      }
    ];
  };
  pve = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs-stable
        system
        ;
    };
    modules = [
      inputs.disko.nixosModules.disko
      ./pve
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs pkgs-stable;
        };
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
        ];
        home-manager.users.morgan = {
          imports = [
            ../../home.nix
          ];
        };
      }
    ];
  };
}
