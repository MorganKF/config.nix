{ pkgs, lib, ... }:
{
  imports = [
    ./features/cli
    ./features/desktop
  ];

  programs = {
    home-manager = {
      enable = true;
    };
  };

  home = {
    packages = with pkgs; [ ];
    stateVersion = "24.11";
  };

  features = {
    cli = {
      nushell.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
    };
    desktop = {
      niri.enable = lib.mkDefault false;
    };
  };
}
