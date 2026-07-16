{
  flake.nixosModules.git = {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Tim Zechmeister";
          email = "tim.zechmeister03@gmail.com";
        };
      };
    };
  };
}
