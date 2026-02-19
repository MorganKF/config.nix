{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "nct6687d"
    "uinput"
    "usbhid"
  ];
  boot.blacklistedKernelModules = [
    "wacom"
    "hid_uclogic"
  ];

  # Explicitly enable udisks2
  services.udisks2.enable = true;

  # Basic nnetworking setup
  networking.hostName = "Everest";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    # Ports for synergy 3
    24800
    24802
    24804
  ];

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable docker
  virtualisation.docker.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.gamemode.enable = true;

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
      "docker"
      "gamemode"
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
      lsfg-vk
      lsfg-vk-ui
      osu-lazer-bin
      signal-desktop
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

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire.noresample = {
      "context.properties" = {
        "default.clock.rate" = 192000;
        "default.clock.allowed-rates" = [
          44100
          48000
          192000
        ];
      };
    };
  };

  # Cooler setup
  programs.coolercontrol.enable = true;
  services.udev.packages = [ pkgs.liquidctl ];

  # Rgb settings
  services.hardware.openrgb.enable = true;

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Enable open-tablet-driver
  hardware = {
    opentabletdriver.enable = true;
    uinput.enable = true;
  };

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

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    package =
      let
        base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "590.48.01";
          sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
          openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
          settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
          persistencedSha256 = "";
        };
        cachyos-nvidia-patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
          sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
        };

        # Patch the appropriate driver based on config.hardware.nvidia.open
        driverAttr = if config.hardware.nvidia.open then "open" else "bin";
      in
      base
      // {
        ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
        });
      };

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
