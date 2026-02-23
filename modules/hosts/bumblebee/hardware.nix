{
  flake.modules.nixos.bumblebee =
    { config, lib, ... }:
    {
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/764b349e-a8ce-4eb4-8504-92abe1d2775d";
        fsType = "ext4";
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/1b364ad9-d9e4-4fb9-81ca-2d3ec369dc89"; }
      ];

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
