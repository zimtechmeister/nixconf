{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
      (import ./_stylix-config.nix self.themeNoHash)
    ];

    home-manager.sharedModules = [
      { home.pointerCursor.enable = true; }
    ];
  };
  flake.homeModules.stylix = {
    imports = [
      inputs.stylix.homeModules.stylix
      (import ./_stylix-config.nix self.themeNoHash)
    ];

    home.pointerCursor.enable = true;
  };
}
