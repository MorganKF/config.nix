{
  vars,
  pkgs,
  config,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    aws-vault
    colima
    docker-client
    docker-compose
    _1password-cli
  ];

  services.openssh.enable = true;
  users.users.${vars.user}.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHyziKmJqEMI3C3/nV/lt32x0/ma1xfoKogmlHjbS+bjAAAADHNzaDp5dWJpa2V5NQ== ssh:yubikey5"
  ];

  # Only sleep the computer after 2h
  power.sleep.display = "never";
  power.sleep.computer = 120;

  homebrew = {
    taps = [ ];
    brews = [ ];
    casks = [
      "mongodb-compass"
      "1password"
      "slack"
      "postman"
      "zoom"
      "caffeine"
    ];
  };
}
