{ ... }: {
  flake.homeModules.lsd = { lib, config, ... }: {
    programs.lsd = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
