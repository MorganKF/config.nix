{ config, lib, ... }:
with lib;
let
  nushell = config.features.cli.nushell;
in
{
  options.features.cli.nushell.enable = mkEnableOption "Enable nushell";

  config = mkIf nushell.enable {
    programs.nushell = {
      enable = true;
      extraConfig = builtins.readFile ./config.nu;
    };

    programs = {
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
      carapace.enable = true;
      starship.enable = true;
    };
  };
}
