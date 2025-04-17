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
    slack
    postman
    colima
    docker
    docker-compose
    firefox-unwrapped
    google-chrome
    zoom-us
    _1password-cli
  ];

  # Setup trampolines to let spotlight find nix apps
  system.activationScripts.postUserActivation.text = ''
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
  '';

  services.openssh.enable = true;
  users.users."${vars.user}".openssh.authorizedKeys.keys = [
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
    ];
  };
}
