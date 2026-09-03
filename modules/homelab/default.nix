{self, ...}: {
  flake.nixosModules.homelab = {
    imports = [
      self.nixosModules.immich
      self.nixosModules.newt
      self.nixosModules.nextcloud

      # self.nixosModules.dyndns
      # self.nixosModules.minecraft-server
      # self.nixosModules.paperless
    ];
  };

  flake.nixosModules.default-homelab = self.nixosModules.homelab;
}
