{
  flake.modules.nixos.package-managers =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [ gearlever ];
      services.flatpak.enable = true;
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
  # TODO: darwin brew
}
