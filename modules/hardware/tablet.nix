{
  flake.modules.nixos.tablet =
    { pkgs, config, ... }:
    {
      boot = {
        kernelModules = [
          "uinput"
          "usbhid"
        ];

        blacklistedKernelModules = [
          "wacom"
          "hid_uclogic"
        ];
      };

      hardware = {
        opentabletdriver.enable = true;
        uinput.enable = true;
      };
    };
}
