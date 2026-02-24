{
  flake.modules.nixos.transmission =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [ transmission_4-qt ];
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        settings = {
          download-dir = lib.mkDefault "${config.xdg.configHome}/torrents";
        };
      };
    };
}
