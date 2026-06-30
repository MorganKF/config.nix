{ inputs, ... }: {
  flake.modules.darwin.determinate = {
    imports = [ inputs.determinate.darwinModules.default ];

    # Nix is managed by determinate nix
    nix.enable = false;
  };
}
