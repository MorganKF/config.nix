{
  config,
  lib,
  pkgs,
  ...
}:
let
  niri = config.features.desktop.niri;
in
{
  options.features.desktop.niri.enable = lib.mkEnableOption "Enable Niri";
  config = lib.mkIf niri.enable {
    home.packages = with pkgs; [
      niri
      xwayland-satellite
    ];

    programs = {
      swaylock.enable = true;
      fuzzel.enable = true;
    };

    services = {
      mako.enable = true;
      swayidle.enable = true;
      polkit-gnome.enable = true;
    };

    xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
  };
}
