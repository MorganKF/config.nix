{ inputs, ... }:
{
  # Configure Neovim with Nix

  flake-file.inputs = {
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  # Export nixvim as a standalone runnable package
  perSystem =
    { system, pkgs, ... }:
    {
      packages.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvim {
        package = inputs.neovim-nightly.packages.${system}.default;
        imports = [ ./_config ];
      };
    };
}
