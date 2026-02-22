{
  flake.modules.nixos.networking = {
    networking.networkmanager.enable = true;

    networking.firewall.allowedTCPPorts = [
      # Ports for synergy 3
      24800
      24802
      24804
    ];
  };
}
