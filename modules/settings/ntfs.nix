{
  flake.modules.nixos.ntfs =
    { pkgs, ... }:
    {
      boot.supportedFilesystems = [ "ntfs" ];
      environment.systemPackages = with pkgs; [ ntfs3g ];
    };
}
