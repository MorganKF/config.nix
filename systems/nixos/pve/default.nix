{
  pkgs,
  vars,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  services.qemuGuest.enable = true;

  boot = {
    growPartition = true;
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      datasource_list = [
        "NoCloud"
        "ConfigDrive"
      ];
      datasource = {
        NoCloud = {
          seedfrom = "/dev/sr0";
        };
      };
      cloud_init_modules = [
        "migrator"
        "seed_random"
        "bootcmd"
        "write-files"
        "growpart"
        "resizefs"
        "update_etc_hosts"
        "set_hostname"
        "update_hostname"
        "ca-certs"
        "rsyslog"
      ];
      users = {
        disable_root = false;
        users = [ ];
      };

      ssh = {
        emit_keys_to_console = false;
        allow_public_ssh_keys = false;
      };
    };
  };

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  networking = {
    hostName = "nixos-pve";
    useDHCP = lib.mkForce false;
    useNetworkd = true;
  };

  systemd.network.enable = true;

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users."${vars.user}" = {
    name = "${vars.user}";
    home = "/home/${vars.user}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHyziKmJqEMI3C3/nV/lt32x0/ma1xfoKogmlHjbS+bjAAAADHNzaDp5dWJpa2V5NQ== ssh:yubikey5"
    ];
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  users.defaultUserShell = pkgs.nushell;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
