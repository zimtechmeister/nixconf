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
      ghostty = self'.packages.ghostty;
      cursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
      };
    };
    packages.xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    devShells.hyprland = pkgs.mkShell {
      buildInputs = [self'.packages.hyprland];
    };
  };
}
