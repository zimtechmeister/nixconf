{inputs, ...}: {
  flake.nixosModules.secrets = {pkgs, ...}: {
    imports = [
      inputs.agenix.nixosModules.default
    ];

    age.secrets = {
      root-password.file = ../../_secrets/root-password.age;
      tim-password.file = ../../_secrets/tim-password.age;
      disk-encryption.file = ../../_secrets/disk-encryption.age;
    };
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
