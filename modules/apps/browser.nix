{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.browser = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisablePocket = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
          TopSites = true;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      chromium
    ];
  };
}
