{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
      };
    };
  };

  flake.modules.darwin.ssh = {
    services.openssh = {
      enable = true;
    };
  };
}
