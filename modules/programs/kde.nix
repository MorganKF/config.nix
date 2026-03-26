{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vulkan-hdr-layer-kwin6
      ];
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
      programs.kdeconnect.enable = true;
    };
}
