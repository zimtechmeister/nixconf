{
  flake.nixosModules.immich = {
    pkgs,
    config,
    ...
  }: {
    # SOPS placeholder:
    # 1. Add secret to secrets.yaml or secrets/hosts/optiplex3000.yaml:
    #    immich-secrets: "DB_PASSWORD=...\n"
    # 2. Uncomment the sops.secrets entry and switch secretsFile below:
    # sops.secrets."immich-secrets" = {
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };

    services.immich = {
      enable = true;
      port = 2283;
      # host = "immich.timzechmeister.de";
      openFirewall = false;
      # secretsFile = config.sops.secrets."immich-secrets".path;
      settings.server.externalDomain = "https://immich.timzechmeister.de";
      accelerationDevices = null; # null gives access to all devices
    };

    # Accelerated Video Playback
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Optionally, set the environment variable
    users.users.immich.extraGroups = ["video" "render"];
  };
}
