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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
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
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt-rfc-style
              git
              (pkgs.rustPlatform.buildRustPackage rec {
                pname = "nur";
                version = "0.15.2";
                useFetchCargoVendor = true;
                src = pkgs.fetchFromGitHub {
                  owner = "nur-taskrunner";
                  repo = "nur";
                  rev = "v${version}";
                  sha256 = "sha256-byRPrgFEiGb/scSc+xHc6rmRvtM9/GSRxgRqyxOaC4c=";
                };
                cargoHash = "sha256-w1jGcSUJv4H6c+yLcciWfMr9zxHF8GeiSyWls0mc+oY=";
                nativeBuildInputs = with pkgs; [
                  pkg-config
                ];
                buildInputs = with pkgs; [ openssl ];

                # openssl-sys required dependencies
                OPENSSL_DIR = "${pkgs.openssl.dev}";
                OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
                OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
              })
            ];
          };
        };
    in
    {
      nixosConfigurations =
        let
          wsl = import ./systems/wsl {
            inherit (nixpkgs) lib;
            inherit inputs;
          };
          nix = import ./systems/nixos {
            inherit (nixpkgs) lib;
            inherit inputs;
          };
        in
        wsl // nix;

      darwinConfigurations = (
        import ./systems/darwin {
          inherit (nixpkgs) lib;
          inherit inputs;
        }
      );

      devShells = forAllSystems devShell;
    };
}
