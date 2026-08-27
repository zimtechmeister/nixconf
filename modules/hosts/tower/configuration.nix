{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostTower
    ];
  };

  flake.nixosModules.hostTower = {
    imports = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.tower

      self.nixosModules.base
      self.nixosModules.default-desktop

      # self.nixosModules.gaming
      # self.nixosModules.virt-manager
    ];

    hardware.facter.reportPath = ./facter.json;

    networking.hostName = "tower";

    boot.loader.limine = {
      extraEntries = ''
        /Windows 11
        protocol: efi
        path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      secureBoot.autoEnrollKeys.extraArgs = [
        "--microsoft"
        "--firmware-builtin"
      ];
    };
  };
}
