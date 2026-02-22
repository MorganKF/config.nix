{
  flake.modules.homeManager.kitty =
    {
      pkgs,
      ...
    }:
    {
      programs.kitty = {
        enable = true;
        font.package = pkgs.nerd-fonts.jetbrains-mono;
        font.name = "JetBrainsMono Nerd Font";
      };
    };
}
