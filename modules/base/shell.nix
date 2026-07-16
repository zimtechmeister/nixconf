{self, ...}: {
  flake.nixosModules.shell = {pkgs, ...}: {
    programs.fish = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.shell;
    };
    users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell;
  };
}
