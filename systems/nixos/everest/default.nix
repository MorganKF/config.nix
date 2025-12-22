{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_17;
  boot.kernelModules = [ "nct6687d" ];

  # Explicitly enable udisks2
  services.udisks2.enable = true;

  networking.hostName = "Everest";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    24800
    24802
    24804
  ];

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Setup user
  users.users.morganf = {
    isNormalUser = true;
    description = "Morgan Fudge";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
    ];
    packages = with pkgs; [
      thunderbird
      teamspeak6-client
      vesktop
      gitkraken
      gparted
      liquidctl
      lm_sensors
      mangohud
      transmission_4-qt
      unrar
    ];
  };

  services.desktopManager.plasma6.enable = true;

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "/storage/torrents";

    };
  };

  #programs.hyprland = {
  #  enable = true;
  #  xwayland.enable = true;
  #};

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Needed for cooling
  programs.coolercontrol.enable = true;
  services.udev.packages = [ pkgs.liquidctl ];

  # Rgb settings
  services.hardware.openrgb.enable = true;

  # Enable ld
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
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
