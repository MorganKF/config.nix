{
  flake.modules.nixos.pipewire =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      security.rtkit.enable = true;
      services = {
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          extraConfig.pipewire.noresample = {
            "context.properties" = {
              "default.clock.rate" = 192000;
              "default.clock.allowed-rates" = [
                44100
                48000
                192000
              ];
            };
          };
        };
      };
    };
}
