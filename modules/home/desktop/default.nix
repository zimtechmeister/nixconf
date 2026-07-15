{ self, ... }: {
  flake.homeModules.desktop = {
    imports = [
      self.homeModules.autostart-hyprland
      self.homeModules.ghostty
      self.homeModules.gtk-styling
      self.homeModules.hyprpolkitagent
      self.homeModules.mimeApps
      self.homeModules.vesktop
    ];
  };
}
