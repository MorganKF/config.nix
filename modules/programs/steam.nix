{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        unstable.protonup-qt
        mangohud
        lsfg-vk
        lsfg-vk-ui
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    };
}
