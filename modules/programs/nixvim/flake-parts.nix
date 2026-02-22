{ inputs, ... }:
{
  # Configure Neovim with Nix

  flake-file.inputs = {
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.modules.nixos.system-cli = {
    nixpkgs.overlays = [
      (final: prev: {
        neovim-nightly = inputs.neovim-nightly.packages.${prev.system}.default;
      })
    ];
  };
}
