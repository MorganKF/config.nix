{ inputs, vars, ... }:
let
  system = "aarch64-darwin";

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
  milk = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs
        pkgs-stable
        system
        vars
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
          inherit pkgs-stable;
        };
        home-manager.users."${vars.user}" = {
          imports = [
            ../../home
            ./milk/home.nix
          ];
        };
      }
    ];
  };
}
