{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  environment.systemPackages = with pkgs; [
    kitty
    protonup-qt
  ];

  users.defaultUserShell = pkgs.nushell;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  services.flatpak.enable = true;
}
