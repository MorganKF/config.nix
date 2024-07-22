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

  home = {
    packages = [ ];
  };
}
