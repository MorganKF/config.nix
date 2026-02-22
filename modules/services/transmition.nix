{
  flake.modules.nixos.transmission =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        settings = {
          download-dir = lib.mkDefault "${config.xdg.configHome}/torrents";
        };
      };
    };
}
