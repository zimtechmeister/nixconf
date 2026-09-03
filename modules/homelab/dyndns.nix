{
  flake.nixosModules.dyndns = {
    config,
    lib,
    ...
  }: {
    # SOPS placeholder:
    # 1. Add secret to secrets.yaml or secrets/hosts/optiplex3000.yaml:
    #    cloudflare-dyndns-api-token: "..."
    # 2. Uncomment the sops.secrets entry and switch apiTokenFile below:
    # sops.secrets."cloudflare-dyndns-api-token" = {
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };

    # Temporary plaintext fallback / placeholder
    environment.etc."cloudflare-dyndns-api-token".text = lib.mkDefault "";

    services.cloudflare-dyndns = {
      enable = true;
      domains = ["timzechmeister.de"];
      apiTokenFile = lib.mkDefault "/etc/cloudflare-dyndns-api-token";
      # apiTokenFile = config.sops.secrets."cloudflare-dyndns-api-token".path;
      ipv4 = false;
      ipv6 = true;
      proxied = false;
    };
  };
}
