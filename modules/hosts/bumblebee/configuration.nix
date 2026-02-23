{ inputs, ... }:
{
  flake.modules.nixos.bumblebee =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-desktop
        default-boot
        ntfs
        nvidia
        kde
      ];

      # tz / localization
      time.timeZone = "America/St_Johns";
      i18n.defaultLocale = "en_CA.UTF-8";

      system.stateVersion = "24.11";
    };
}
