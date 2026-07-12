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

  # TODO: combine modules
  flake.nixosModules.hostMain = {
    imports = [
      ./_hardware-configuration.nix
      self.nixosModules.base
      self.nixosModules.base-packages
      self.nixosModules.plymouth
      self.nixosModules.secrets
      self.nixosModules.ssh
      self.nixosModules.users
      self.nixosModules.hyprland
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
