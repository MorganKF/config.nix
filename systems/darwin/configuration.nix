{ vars, pkgs, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
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

    stateVersion = 4;
  };

  # Enable terminal touch id instead of passwd
  security.pam.services.sudo_local.touchIdAuth = true;

  users.users."${vars.user}" = {
    name = "${vars.user}";
    home = "/Users/${vars.user}";
  };

  programs.zsh.enable = true;

  environment.systemPackages = [ ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    taps = [ ];
    brews = [ ];
    casks = [
      "iterm2"
      "font-jetbrains-mono-nerd-font" # TODO: Install from nix nerdfont package
    ];
  };
}
