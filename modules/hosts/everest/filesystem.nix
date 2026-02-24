{
  flake.modules.nixos.everest = {
    # NAS nfs mount
    fileSystems."/mnt/ryukyu" = {
      device = "ryukyu.homelan:/mnt/user";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "noauto"
      ];
    };

  };
}
