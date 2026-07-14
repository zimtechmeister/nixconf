{ ... }: {
  flake.homeModules.git = { lib, config, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Tim Zechmeister";
          email = "tim.zechmeister03@gmail.com";
        };
      };
    };
  };
}
