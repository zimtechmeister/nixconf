{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostT480
    ];
  };

  flake.nixosModules.hostT480 = {
    imports = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.t480
      ./_hardware-configuration.nix
      self.nixosModules.base
      self.nixosModules.base-packages
      self.nixosModules.users
      self.nixosModules.gnome
      self.nixosModules.desktop-packages
      self.nixosModules.bluetooth
    ];

    networking.hostName = "t480";

    boot.loader.limine = {
      secureBoot.autoEnrollKeys.extraArgs = [
        "--microsoft"
        "--ignore-immutable"
      ];
    };
  };
}
