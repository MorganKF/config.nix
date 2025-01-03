{ pkgs, ... }:
let
  envVars = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
in
{
  programs = {
    home-manager.enable = true;
  };

  home = {
    packages = with pkgs; [ just ];
    sessionVariables = envVars;
    stateVersion = "24.11";
  };
  
  imports = [ (import ./features/cli {inherit envVars pkgs;}) ];
}
