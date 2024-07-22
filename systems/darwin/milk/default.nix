{ pkgs-unstable, ... }: {

  environment.systemPackages = with pkgs-unstable; [ aws-vault ];

  homebrew = {
    taps = [ ];
    brews = [ ];
    casks = [ "mongodb-compass" "docker" "postman" ];
  };
}
