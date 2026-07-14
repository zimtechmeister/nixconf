{ ... }: {
  flake.homeModules.jujutsu = { lib, config, ... }: {
    programs.jujutsu = {
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
