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

  nix = {
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  services.qemuGuest.enable = true;

  boot = {
    growPartition = true;
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    initrd.availableKernelModules = [
      "cdrom"
    ];
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
      ];
      datasource = {
        NoCloud = {
          dsmode = "local";
        };
      };

      # Disable user and ssh key creation
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

  # Mount cloud-init drive
  fileSystems."/var/lib/cloud/seed/nocloud" = {
    device = "/dev/sr0";
    fsType = "iso9660";
    options = [
      "ro"
      "nofail"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/cloud/seed/nocloud 0755 root root - -"
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

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

  networking = {
    hostName = "nixos-pve";
    useDHCP = lib.mkForce false;
    useNetworkd = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPortRanges = [
        {
          from = 3000;
          to = 3999;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 3000;
          to = 3999;
        }
      ];
    };
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Nix Dev Samba Server";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.2. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "public" = {
        "path" = "/home/${vars.user}/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${vars.user}";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
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

  users.defaultUserShell = pkgs.nushell;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
