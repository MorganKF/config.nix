{ inputs, ... }:
{
  flake.modules.darwin.work-mac =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        system-desktop
      ];

      environment.systemPackages = with pkgs; [
        opencode
        awscli2
        aws-sam-cli
        ssm-session-manager-plugin
        fnm
      ];

      system.stateVersion = "26.05";
    };
}
