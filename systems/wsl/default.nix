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
  wsl = inputs.nixpkgs.lib.nixosSystem {
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
      ./configuration.nix
      inputs.nixos-wsl.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit pkgs-stable;
        };
        home-manager.users.nixos = {
          imports = [
            ../../home
          ];
        };
      }
    ];
  };
}
