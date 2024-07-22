{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      vars = {
        user = "morgan";
      };
    in
    {
      darwinConfigurations = (
        import ./systems/darwin {
          inherit (nixpkgs) lib;
          inherit inputs vars;
        }
      );

      devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
        nativeBuildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [ nixfmt-rfc-style ];
      };
    };
}
