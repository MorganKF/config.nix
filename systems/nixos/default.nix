{ inputs, vars, ... }:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

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
        vars
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
          inputs.nixvim.homeManagerModules.nixvim
        ];
        home-manager.users."${vars.user}" = {
          imports = [
            ../../home.nix
            ./bumblebee/home.nix
          ];
        };
      }
    ];
  };
}
