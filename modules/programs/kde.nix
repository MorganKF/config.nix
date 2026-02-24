{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      services = {
        udisks2.enable = true;
        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "";
          };
        };
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
      };
    };
}
