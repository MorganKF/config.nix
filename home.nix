{ pkgs, lib, ... }:
{
  imports = [ ./features/cli ];

  programs = {
    home-manager = {
      enable = true;
    };
  };

  home = {
    packages = with pkgs; [ just ];
    stateVersion = "24.11";
  };

  features.cli = {
    nushell.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
  };
}
