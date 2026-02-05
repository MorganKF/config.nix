{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  helix = config.features.cli.helix;
in
{
  options.features.cli.helix.enable = mkEnableOption "Enable helix";

  config = mkIf helix.enable {
    programs = {
      helix = {
        enable = true;
        languages = {
          language-server = {
            typescript-language-server = {
              command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
              args = [ "--stdio" ];
              config = {
                tsserver = {
                  path = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib";
                };
              };
            };
            nil = {
              command = "${pkgs.nil}/bin/nil";
            };
          };
          language = [
            {
              name = "cpp";
              auto-format = true;
            }
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = "${pkgs.nixfmt}/bin/nixfmt";
              };
            }
          ];
        };
        settings = {
          theme = "dracula_at_night";
          editor = {
            true-color = true;
          };
        };
      };
    };
  };
}
