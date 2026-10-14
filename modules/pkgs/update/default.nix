{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: let
    updateScript = pkgs.writeShellApplication {
      name = "update";
      runtimeInputs = with pkgs; [
        git
        nix
      ];
      text = ''
        nix flake update
        nix run nixpkgs#nix-update -- --flake helium
      '';
    };
  in {
    packages.update = updateScript;
    apps.update = {
      type = "app";
      program = lib.getExe self'.packages.update;
    };
  };
}
