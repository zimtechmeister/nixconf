{self, ...}: {
  flake.nixosModules.base = {
    imports = [
      self.nixosModules.system
      self.nixosModules.fwupd
      self.nixosModules.git
      self.nixosModules.home-manager
      self.nixosModules.nix
      self.nixosModules.base-packages
      self.nixosModules.plymouth
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh
      self.nixosModules.stylix
      self.nixosModules.television
      self.nixosModules.users
      self.nixosModules.zoxide
      self.nixosModules.zram
    ];
  };
}
