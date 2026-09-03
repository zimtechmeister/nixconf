{
  flake.nixosModules.nextcloud = {
    pkgs,
    config,
    lib,
    ...
  }: {
    # SOPS placeholder:
    # 1. Add secret to secrets.yaml or secrets/hosts/optiplex3000.yaml:
    #    nextcloud-admin-pass: "..."
    # 2. Uncomment the sops.secrets entry and switch adminpassFile below:
    # sops.secrets."nextcloud-admin-pass" = {
    #   owner = "nextcloud";
    #   group = "nextcloud";
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };

    # Temporary plaintext fallback / placeholder
    environment.etc."nextcloud-admin-pass".text = lib.mkDefault "";

    services = {
      nextcloud = {
        enable = true;
        # need to manually increment with new nextcloud versions
        package = pkgs.nextcloud32;
        hostName = "localhost";
        https = false;
        configureRedis = true;
        maxUploadSize = "1G";
        # Storage path of nextcloud
        # home = "/var/lib/nextcloud";
        config = {
          dbtype = "sqlite";
          adminuser = "root";
          adminpassFile = lib.mkDefault "/etc/nextcloud-admin-pass";
          # adminpassFile = config.sops.secrets."nextcloud-admin-pass".path;
        };
        settings = {
          default_phone_region = "DE";
          trusted_domains = [
            "nextcloud.timzechmeister.de"
            "192.168.0.3"
            "localhost"
          ];
          # Disable external storage by default for security
          # "allow_local_remote_servers" = false;
        };
      };
    };
  };
}
