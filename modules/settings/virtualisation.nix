{
  flake.modules.nixos.virtualisation = {
    virtualisation.docker.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
