{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.11";
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
                version = "0.20.0+0.108.0";
                src = pkgs.fetchFromGitHub {
                  owner = "nur-taskrunner";
                  repo = "nur";
                  rev = "v${version}";
                  sha256 = "sha256-9WsuHKeOOL1bEkHPFvA+onKWfeuKe6GWg1Jmjb7qQts=";
                };
                cargoHash = "sha256-dkYGrEMaF20uWZo6G7aukkoV0AiTON1AVfeXPfOsBuo=";
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
