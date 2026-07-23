{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    self',
    theme,
    ...
  }: {
    packages.hyprland = pkgs.callPackage ./_wrapper.nix {
      inherit inputs theme;
      noctalia = self'.packages.noctalia;
      vicinae = self'.packages.vicinae;
      ghostty = self'.packages.ghostty-wrapped;
    };
    packages.xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    devShells.hyprland = pkgs.mkShell {
      buildInputs = [self'.packages.hyprland];
    };
  };
}
