{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostMain
    ];
  };

  flake.nixosModules.hostMain = {
    imports = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.main

      self.nixosModules.base
      self.nixosModules.default-desktop

      self.nixosModules.gaming
      self.nixosModules.virt-manager
    ];

    hardware.facter.reportPath = ./facter.json;

    networking.hostName = "main";

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
