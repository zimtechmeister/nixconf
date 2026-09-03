{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.optiplex3000 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostOptiplex3000
    ];
  };

  flake.nixosModules.hostOptiplex3000 = {
    imports = [
      # Disko configuration (add disko.nix later):
      # inputs.disko.nixosModules.disko
      # self.diskoConfigurations.optiplex3000

      self.nixosModules.base
      self.nixosModules.homelab
    ];

    # Hardware facter report (add facter.json later):
    # hardware.facter.reportPath = ./facter.json;

    networking.hostName = "optiplex3000";

    boot.loader.limine = {
      secureBoot.autoEnrollKeys.extraArgs = [
        "--microsoft"
        "--firmware-builtin"
      ];
    };
  };
}
