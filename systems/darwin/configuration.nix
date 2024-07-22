{ user, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc.automatic = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  users.users."${user}" = {
    name = "${user}";
    home = "/Users/${user}";
  };

  programs.zsh.enable = true;

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
