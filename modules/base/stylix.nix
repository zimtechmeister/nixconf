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
  };
  flake.homeModules.stylix = {
    imports = [
      inputs.stylix.homeModules.stylix
      (import ./_stylix-config.nix self.themeNoHash)
    ];
  };
}
