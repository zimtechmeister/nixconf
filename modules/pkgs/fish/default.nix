{
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.fish = pkgs.callPackage ./_wrapper.nix {};
    apps.fish = {
      type = "app";
      program = lib.getExe self'.packages.fish;
    };
    devShells.fish = pkgs.mkShell {
      buildInputs = [self'.packages.fish];
    };
  };
}
