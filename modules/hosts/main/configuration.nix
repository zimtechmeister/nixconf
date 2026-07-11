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
      ./_hardware-configuration.nix
      self.nixosModules.base
      self.nixosModules.base-packages
      self.nixosModules.users
      self.nixosModules.gnome
      self.nixosModules.desktop-packages
    ];

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
