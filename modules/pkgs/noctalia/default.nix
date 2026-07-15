{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.noctalia = pkgs.callPackage ./_wrapper.nix {
      inherit inputs;
    };
    devShells.noctalia = pkgs.mkShell {
      buildInputs = [self'.packages.noctalia];
    };
  };
}
