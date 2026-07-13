{inputs, ...}: {
  flake.nixosModules.secrets = {pkgs, ...}: {
    imports = [
      inputs.agenix.nixosModules.default
    ];

    age.secrets = {
      root-password.file = ../../secrets/root-password.age;
      tim-password.file = ../../secrets/tim-password.age;
      disk-encryption.file = ../../secrets/disk-encryption.age;
    };
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
