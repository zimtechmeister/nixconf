{ self, ... }: {
  flake.homeModules.default = {
    imports = [
      self.homeModules.general
    ];

    home = {
      username = "tim";
      homeDirectory = "/home/tim";

      stateVersion = "26.05";
    };
    # Let's Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
