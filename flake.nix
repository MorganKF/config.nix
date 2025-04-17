{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.11";
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
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-generators,
      ...
    }@inputs:
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
      forAllVMs =
        f:
        nixpkgs.lib.genAttrs linuxSystems (
          system:
          f {
            inherit system;
          }
        );
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ nixfmt-rfc-style ];
            packages = with pkgs; [ nil ];
          };
        };
    in
    {
      nixosConfigurations =
        let
          wsl = import ./systems/wsl {
            inherit (nixpkgs) lib;
            inherit inputs vars;
          };
          nix = import ./systems/nixos {
            inherit (nixpkgs) lib;
            inherit inputs vars;
          };
        in
        wsl // nix;

      darwinConfigurations = (
        import ./systems/darwin {
          inherit (nixpkgs) lib;
          inherit inputs vars;
        }
      );

      packages = forAllVMs (
        { system }:
        {
          proxmox = nixos-generators.nixosGenerate {
            inherit system;
            format = "proxmox";
            specialArgs = { inherit vars inputs; };
            modules = [
              {
                nix.registry.nixpkgs.flake = nixpkgs;
                virtualisation.diskSize = 20 * 1024;
                hardware.enableRedistributableFirmware = true;
              }
              ./systems/nixos/pve/default.nix
            ];
          };
        }
      );

      devShells = forAllSystems devShell;
    };
}
