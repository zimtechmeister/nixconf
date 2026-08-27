{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: let
    installScript = pkgs.writeShellApplication {
      name = "install";
      runtimeInputs = with pkgs; [
        bash
        coreutils
        git
        gnugrep
        gnused
        nixos-anywhere
        openssh
        sops
        age
        ssh-to-age
      ];
      text = builtins.readFile ./install.sh;
    };
  in {
    packages.install = installScript;
    apps.install = {
      type = "app";
      program = lib.getExe self'.packages.install;
    };
  };
}
