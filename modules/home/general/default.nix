{ self, ... }: {
  flake.homeModules.general = {
    imports = [
      self.homeModules.fastfetch
      self.homeModules.fish
      self.homeModules.git
      self.homeModules.jujutsu
      self.homeModules.lsd
      self.homeModules.neovide
      self.homeModules.nushell
      self.homeModules.ssh
      self.homeModules.starship
      self.homeModules.yazi
      self.homeModules.zoxide
    ];
  };
}
