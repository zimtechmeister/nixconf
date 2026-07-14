{ ... }: {
  flake.homeModules.gtk-styling = { lib, config, ... }: {
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":";
      };
    };
  };
}
