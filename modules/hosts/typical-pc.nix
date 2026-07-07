{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.typical-pc = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      self.nixosModules.base
      self.nixosModules.gnome
      self.nixosModules.browser
      self.nixosModules.default-apps
    ];
  };
}
