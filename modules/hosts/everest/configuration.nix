{ inputs, ... }:
{
  flake.modules.nixos.everest =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-desktop
        default-boot
        tablet
        nvidia
        kde
      ];

      # Add kernel module for getting motherboard sensor data
      boot.kernelModules = [ "nct6687d" ];

      # tz / localization
      time.timeZone = "America/St_Johns";
      i18n.defaultLocale = "en_CA.UTF-8";

      # Cooler / RGB control
      environment.systemPackages = with pkgs; [
        liquidctl
        lm_sensors
      ];
      programs.coolercontrol.enable = true;
      services = {
        hardware.openrgb.enable = true;
        udev.packages = [ pkgs.liquidctl ];
      };

      # Reroute transmission files to spare drive
      services.transmission.settings.download-dir = "/storage/torrents";

      system.stateVersion = "25.11";
    };
}
