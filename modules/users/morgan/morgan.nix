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
        { pkgs, ... }:
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
          };
        };
    }
  ];
}
