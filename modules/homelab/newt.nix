{
  flake.nixosModules.newt = {
    config,
    lib,
    ...
  }: {
    # SOPS placeholder:
    # 1. Add secret to secrets.yaml or secrets/hosts/optiplex3000.yaml:
    #    newt-secret: "..."
    # 2. Uncomment the sops.secrets entry and switch environmentFile below:
    # sops.secrets."newt-secret" = {
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };

    # Temporary plaintext fallback / placeholder
    environment.etc."newt-secret".text =
      lib.mkDefault ''
      '';

    services.newt = {
      enable = true;
      # settings = {
      #   endpoint = "https://pangolin.timzechmeister.de";
      # };
      environmentFile = lib.mkDefault "/etc/newt-secret";
      # environmentFile = config.sops.secrets."newt-secret".path;
    };
  };
}
