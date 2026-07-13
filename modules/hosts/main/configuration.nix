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
      self.nixosModules.cachix
      self.nixosModules.fwupd
      self.nixosModules.nix
      self.nixosModules.base-packages
      self.nixosModules.plymouth
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh
      self.nixosModules.television
      self.nixosModules.users
      self.nixosModules.zram

      self.nixosModules.fonts
      self.nixosModules.hyprland
      self.nixosModules.localsend
      self.nixosModules.desktop-packages
      self.nixosModules.virt-manager

      self.nixosModules.gaming
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
