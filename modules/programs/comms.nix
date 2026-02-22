{
  flake.modules.homeManager.comms =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        teamspeak6-client
        vesktop
        signal-desktop
      ];
    };
}
