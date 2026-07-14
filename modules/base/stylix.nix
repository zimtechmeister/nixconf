{ self, inputs, ... }: {
  flake.nixosModules.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
      (import ./_stylix-config.nix self.themeNoHash)
    ];
  };

  flake.homeModules.stylix = {
    imports = [
      (import ./_stylix-config.nix self.themeNoHash)
    ];
  };
}
