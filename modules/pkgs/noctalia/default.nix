{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    theme,
    ...
  }: {
    packages.noctalia = pkgs.callPackage ./_wrapper.nix {
      inherit inputs theme;
    };
    devShells.noctalia = pkgs.mkShell {
      buildInputs = [self'.packages.noctalia];
    };
  };
}
