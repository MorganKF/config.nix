{ pkgs, vars, ... }:
{
  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  users.users."${vars.user}" = {
    name = "${vars.user}";
    home = "/home/${vars.user}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    packages = with pkgs; [ kitty ];
  };

  users.defaultUserShell = pkgs.nushell;
}
