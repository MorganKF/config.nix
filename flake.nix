{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      user = "morgan";
    in
    {
      darwinConfigurations = (
        import ./systems/darwin {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            nixpkgs-unstable
            nix-darwin
            home-manager
            user
            ;
        }
      );

      devShells.aarch64-darwin.default = nixpkgs-unstable.legacyPackages.aarch64-darwin.mkShell {
        nativeBuildInputs = with nixpkgs-unstable.legacyPackages.aarch64-darwin; [ nixfmt-rfc-style ];
      };
    };
}
