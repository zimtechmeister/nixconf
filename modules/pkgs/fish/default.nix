{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.fish = import ./_wrapper.nix {
      inherit pkgs;
      inherit inputs;
    };
    apps.fish = {
      type = "app";
      program = lib.getExe self'.packages.fish;
    };
    devShells.fish = pkgs.mkShell {
      buildInputs = [self'.packages.fish];
    };
  };
}
