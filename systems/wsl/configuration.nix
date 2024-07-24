{ pkgs, vars, ... }:
{
  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  wsl.enable = true;

  # Setup everything under the default nixos wsl user
  users.users.nixos = {
    name = "nixos";
    home = "/home/nixos";
    isNormalUser = true;
    shell = pkgs.nushell;
  };

  environment.systemPackages = [ ];

  time.timeZone = "America/St_Johns";

  system = {
    stateVersion = "24.05";
  };
}
