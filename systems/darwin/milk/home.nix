{ ... }:
{
  programs = {
    nushell = {
      extraEnv = ''
        $env.PATH = ($env.PATH | split row (char esep) | append '/opt/homebrew/bin')
      '';
    };
    awscli = {
      enable = true;
    };
  };

  # Disable git managment on MacOS
  programs.git.enable = false;

  home = {
    packages = [ ];
  };
}
