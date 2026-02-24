{
  # Modules for running NixOS on the Windows Subsystem for Linux

  flake-file.inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };
}
