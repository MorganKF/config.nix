{
  lib,
  pkgs,
  vars,
  ...
}:
{
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc = {
    user = "root";
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  services.nix-daemon.enable = true;

  system = {
    defaults = {
      dock = {
        show-recents = false;
        tilesize = 85;
      };
    };

    stateVersion = 4;
  };

  users.users."${vars.user}" = {
    name = "${vars.user}";
    home = "/Users/${vars.user}";
    shell = lib.getExe pkgs.nushell;
  };

  environment.systemPackages = [ ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [ ];
    brews = [ ];
    casks = [
      "iterm2"
      "font-jetbrains-mono-nerd-font"
    ];
  };

  security.pam.enableSudoTouchIdAuth = true;
}
