{self, ...}: {
  flake.nixosModules.shell = {pkgs, ...}: {
    programs.fish = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
    };
    users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
  };
}
