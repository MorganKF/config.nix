{
  pkgs,
  vars,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.growPartition = true;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  networking.hostName = "nixos-pve";
  networking.networkmanager.enable = true;

  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
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
