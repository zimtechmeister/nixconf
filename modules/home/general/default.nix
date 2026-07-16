{ self, ... }: {
  flake.homeModules.general = {
    imports = [
      self.homeModules.starship
    ];
  };
}
