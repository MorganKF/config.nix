{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Explicitly enable udisks2
  services.udisks2.enable = true;

  # Add ntfs-3g to system packages
  environment.systemPackages = with pkgs; [
    ntfs3g
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 2048;
        "default.clock.quantum" = 512;
      };
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
