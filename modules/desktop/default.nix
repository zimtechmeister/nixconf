{self, ...}: {
  flake.nixosModules.default-desktop = {
    imports = [
      self.nixosModules.fonts
      self.nixosModules.hyprland
      self.nixosModules.localsend
      self.nixosModules.desktop-packages
    ];
  };
}
