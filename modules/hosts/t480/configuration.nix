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

      self.nixosModules.fonts
      self.nixosModules.gnome
      self.nixosModules.localsend
      self.nixosModules.desktop-packages

      self.nixosModules.bluetooth
      self.nixosModules.kanata
      self.nixosModules.notebook-power
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
