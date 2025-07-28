{ pkgs, vars, ... }:
{
  nixpkgs.config.allowUnfree = true;

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
    packages = with pkgs; [
      kitty
      teamspeak6-client
      vesktop
      gitkraken
    ];
  };

  users.defaultUserShell = pkgs.nushell;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  services.flatpak.enable = true;
}
