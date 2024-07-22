{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ aws-vault ];

  homebrew = {
    taps = [ ];
    brews = [ ];
    casks = [
      "mongodb-compass"
      "docker"
      "postman"
    ];
  };
}
