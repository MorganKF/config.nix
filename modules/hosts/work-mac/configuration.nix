{ inputs, ... }:
{
  flake.modules.darwin.work-mac =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        system-desktop
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
        "aspnetcore-runtime-6.0.36"
        "dotnet-runtime-6.0.36"
      ];

      environment.systemPackages = with pkgs; [
        opencode
        awscli2
        aws-sam-cli
        ssm-session-manager-plugin
        fnm
        bruno
        (
          with dotnetCorePackages;
          combinePackages [
            sdk_8_0
            sdk_6_0
            aspnetcore_6_0
            runtime_6_0
          ]
        )
      ];

      system.stateVersion = "26.05";
    };
}
