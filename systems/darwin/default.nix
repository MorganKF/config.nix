{ inputs, ... }:
let
  system = "aarch64-darwin";
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  milk = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs-stable
        system
        ;
    };
    modules = [
      ./milk
      ./configuration.nix
      inputs.home-manager.darwinModules.home-manager
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
            ./milk/home.nix
          ];
        };
      }
    ];
  };
}
