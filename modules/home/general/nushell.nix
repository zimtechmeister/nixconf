{ ... }: {
  flake.homeModules.nushell = { lib, config, ... }: {
    programs.nushell = {
      enable = true;
    };
  };
}
