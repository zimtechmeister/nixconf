{self, ...}: {
  flake.nixosModules.shell = {pkgs, lib, ...}: {
    programs.fish = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.shell;
      shellAliases = lib.mkForce {};
    };
    users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell;
  };
}
