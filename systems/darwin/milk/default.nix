{ vars, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ aws-vault ];

  services.openssh.enable = true;
  users.users."${vars.user}".openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHyziKmJqEMI3C3/nV/lt32x0/ma1xfoKogmlHjbS+bjAAAADHNzaDp5dWJpa2V5NQ== ssh:yubikey5"
  ];

  homebrew = {
    taps = [ ];
    brews = [ ];
    casks = [
      "mongodb-compass"
      "docker"
      "postman"
      "1password-cli"
    ];
  };
}
