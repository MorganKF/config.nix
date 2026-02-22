{
  flake.modules.nixos.default-boot =
    { pkgs, ... }:
    {
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        kernelPackages = pkgs.linuxPackages_latest;
      };
    };
}
