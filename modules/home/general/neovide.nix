{ ... }: {
  flake.homeModules.neovide = { lib, config, pkgs, ... }: {
    stylix.targets.neovide.fonts.override = {
      monospace = {
        name = "Monocraft Nerd Font";
        package = pkgs.monocraft;
      };
    };
    programs.neovide = {
      enable = true;
      settings = {
        tabs = true;
        vsync = true;
      };
    };
  };
}
