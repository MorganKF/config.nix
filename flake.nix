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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    let
      vars = {
        user = "morgan";
      };
      linuxSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell { nativeBuildInputs = with pkgs; [ nixfmt-rfc-style ]; };
        };
    in
    {
      nixosConfigurations = (
        import ./systems/wsl {
          inherit (nixpkgs) lib;
          inherit inputs vars;
        }
      );

      darwinConfigurations = (
        import ./systems/darwin {
          inherit (nixpkgs) lib;
          inherit inputs vars;
        }
      );

      devShells = forAllSystems devShell;
    };
}
