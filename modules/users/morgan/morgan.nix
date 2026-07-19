{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "morganf" true)
    {
      nixos.morganf = {
        imports = with self.modules.nixos; [
          virtualisation
          transmission
        ];

        users.users.morganf = {
          extraGroups = [ "docker" ];
        };
      };

      darwin.morganf = {
        power.sleep = {
          display = "never";
          computer = 120;
        };

        system = {
          defaults = {
            dock = {
              show-recents = false;
              tilesize = 85;
              autohide = true;
            };

            finder = {
              AppleShowAllFiles = true;
              AppleShowAllExtensions = true;
              QuitMenuItem = true;
              ShowPathbar = true;
            };

            NSGlobalDomain = {
              AppleShowAllFiles = true;
              AppleShowAllExtensions = true;
            };
          };
        };

        # Enable terminal touch id instead of passwd
        security.pam.services.sudo_local.touchIdAuth = true;
      };

      homeManager.morganf =
        { config, pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
            comms
            kitty
          ];

          home.packages = with pkgs; [
            thunderbird
            filezilla
            libreoffice
            heroic
          ];

          programs = {
            git = {
              settings = {
                user = {
                  email = "morgan@mkf.dev";
                  name = "MorganKF";
                };
              };
            };
            opencode = {
              enable = true;
              package = pkgs.unstable.opencode;
              tui = {
                theme = "tokyonight";
              };
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

                  git = {
                    type = "local";
                    command = [
                      "${pkgs.unstable.uv}/bin/uvx"
                      "mcp-server-git"
                    ];
                    enabled = true;
                  };

                  jcodemunch = {
                    type = "local";
                    command = [
                      "${pkgs.unstable.uv}/bin/uvx"
                      "jcodemunch-mcp"
                    ];
                    enabled = true;
                  };

                  memory = {
                    type = "local";
                    command = [
                      "${pkgs.unstable.nodejs}/bin/npx"
                      "-y"
                      "@modelcontextprotocol/server-memory"
                    ];
                    environment = {
                      MEMORY_FILE_PATH = "${config.xdg.configHome}/opencode/memory.jsonl";
                      PATH = "${pkgs.unstable.nodejs}/bin:/bin:/usr/bin";
                    };
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
              };
            };
          };
        };
    }
  ];
}
