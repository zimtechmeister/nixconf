{inputs, ...}: {
  flake.nixosModules.secrets = {pkgs, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age = {
        # Automatically use the host's SSH ed25519 private key for decryption
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        # Optional fallback or dedicated age key file:
        # keyFile = "/var/lib/sops-nix/key.txt";
      };

      secrets = {
        "root-password-hash" = {
          neededForUsers = true;
        };
        "tim-password-hash" = {
          neededForUsers = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  };
}
