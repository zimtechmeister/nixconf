{
  flake.nixosModules.paperless = {
    config,
    lib,
    ...
  }: {
    # SOPS placeholder:
    # 1. Add secret to secrets.yaml or secrets/hosts/optiplex3000.yaml:
    #    paperless-admin-pass: "..."
    #    paperless-secret-key: "..."
    # 2. Uncomment the sops.secrets entries and switch passwordFile / environmentFile below:
    # sops.secrets."paperless-admin-pass" = {
    #   # owner = "paperless";
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };
    # sops.secrets."paperless-secret-key" = {
    #   # owner = "paperless";
    #   # sopsFile = ../../secrets/hosts/optiplex3000.yaml;
    # };

    # Temporary plaintext fallback / placeholder
    environment.etc."paperless-admin-pass".text = lib.mkDefault "password123";

    services.paperless = {
      # user = "${homelab_user}";
      enable = true;
      passwordFile = lib.mkDefault "/etc/paperless-admin-pass";
      # passwordFile = config.sops.secrets."paperless-admin-pass".path;
      # environmentFile = config.sops.secrets."paperless-secret-key".path;
      settings = {
        PAPERLESS_OCR_LANGUAGES = "deu+eng";
        PAPERLESS_SECRET_KEY = "<redacted>";
        PAPERLESS_TIME_ZONE = "Europe/Berlin";
        PAPERLESS_OCR_LANGUAGE = "deu";
        PAPERLESS_ACCOUNT_SESSION_REMEMBER = "True";
        PAPERLESS_FILENAME_FORMAT = "{{ created_year }}/{{ doc_pk }}_{{ title }}";
        PAPERLESS_CONSUMER_POLLING = 300;
        # Nginx configuration
        # PAPERLESS_URL = "https://${config.networking.hostName}.${tailnet-name}";
        USE_X_FORWARD_HOST = true;
        USE_X_FORWARD_PORT = true;
        PAPERLESS_PROXY_SSL_HEADER = ["HTTP_X_FORWARDED_PROTO" "https"];
        PAPERLESS_FORCE_SCRIPT_NAME = "/paperless";
      };
      exporter = {
        enable = true;
        directory = "/mnt/backups/paperless";
        onCalendar = "weekly";
      };
    };
  };
}
