{ ... }: {
  flake.homeModules.yazi = { lib, config, ... }: {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
