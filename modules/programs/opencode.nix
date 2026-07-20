{
  flake.modules.homeManager.opencode =
    { lib, pkgs, ... }:
    let
      engram = pkgs.buildGoModule rec {
        pname = "engram";
        version = "1.20.0";

        src = pkgs.fetchFromGitHub {
          owner = "Gentleman-Programming";
          repo = "engram";
          rev = "v${version}";
          hash = "sha256-qdKAll7N0HtJRbZYilzatVCUz1Tr+pqM217Y8O+Csjs=";
        };

        vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64=";
        subPackages = [ "cmd/engram" ];
        env.CGO_ENABLED = "0";
        ldflags = [ "-X main.version=${version}" ];
        nativeCheckInputs = [ pkgs.git ];
      };
    in
    {
      home.sessionVariables = {
        ENGRAM_BIN = engram;
        OPENCODE_ENABLE_EXA = "1";
      };

      xdg.configFile."opencode/plugins/engram.ts".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Gentleman-Programming/engram/v1.20.0/plugin/opencode/engram.ts";
        hash = "sha256-wL5hM9LydiwLPIrPpob43pyRuz4NOJMqYuLMbTLFdFA=";
      };

      programs.opencode = {
        enable = true;
        package = pkgs.unstable.opencode;
        tui.theme = "tokyonight";
        settings = {
          lsp = {
            eslint.command = [
              "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server"
              "--stdio"
            ];
            json = {
              command = [
                "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server"
                "--stdio"
              ];
              extensions = [
                ".json"
                ".jsonc"
              ];
            };
            nil = {
              command = [ "${pkgs.nil}/bin/nil" ];
              extensions = [ ".nix" ];
            };
            typescript.command = [
              "${pkgs.typescript-language-server}/bin/typescript-language-server"
              "--stdio"
            ];
          };
          mcp = {
            context7 = {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
              enabled = true;
            };

            engram = {
              type = "local";
              command = [ "${engram}/bin/engram" "mcp" ];
              timeout = 300000;
              enabled = true;
            };

            git = {
              type = "local";
              command = [
                "${pkgs.unstable.uv}/bin/uvx"
                "--python"
                "${pkgs.unstable.python313}/bin/python3"
                "mcp-server-git"
              ];
              environment = {
                PATH = "${pkgs.coreutils}/bin:${pkgs.git}/bin:/bin:/usr/bin";
              };
              timeout = 30000;
              enabled = true;
            };

            jcodemunch = {
              type = "local";
              command = [
                "${pkgs.unstable.uv}/bin/uvx"
                "--python"
                "${pkgs.unstable.python313}/bin/python3"
                "jcodemunch-mcp"
              ];
              environment = {
                PATH = "${pkgs.coreutils}/bin:${pkgs.git}/bin:/bin:/usr/bin";
              }
              // lib.optionalAttrs pkgs.stdenv.isLinux {
                LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
              };
              timeout = 30000;
              enabled = true;
            };

            nixos = {
              type = "local";
              command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
              enabled = true;
            };

            gh_grep = {
              type = "remote";
              url = "https://mcp.grep.app";
              enabled = true;
            };
          };

          plugin = [
            "@ramarivera/opencode-model-announcer@latest"
            "envsitter-guard@latest"
            "@tarquinen/opencode-dcp@latest"
          ];

          permission.websearch = "allow";
        };
      };
    };
}
