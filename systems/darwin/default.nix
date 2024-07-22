{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  nix-darwin,
  home-manager,
  user,
  ...
}:
let
  system = "aarch64-darwin";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  milk = nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        pkgs
        pkgs-unstable
        system
        user
        ;
    };
    modules = [
      ./milk
      ./configuration.nix
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit pkgs-unstable;
        };
        home-manager.users."${user}" = {
          imports = [
            ../../home
            ./milk/home.nix
          ];
        };
      }
    ];
  };
}
