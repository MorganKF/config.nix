{ inputs, ... }:
{
  flake.modules.nixos.everest =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-desktop
        default-boot
        tablet
        game-devices
        nvidia
        kde
      ];

      # Add kernel module for getting motherboard sensor data
      boot.kernelModules = [ "nct6683" ];
      boot.extraModprobeConfig = ''
        options nct6683 force=1
      '';

      # tz / localization
      time.timeZone = "America/St_Johns";
      i18n.defaultLocale = "en_CA.UTF-8";

      # Enable ollama for system
      services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
      };
      services.open-webui = {
        enable = true;
        port = 8888;
      };
      environment.systemPackages = with pkgs; [
        opencode
      ];

      # Reroute transmission files to spare drive
      services.transmission.settings.download-dir = "/storage/torrents";

      system.stateVersion = "25.11";
    };
}
