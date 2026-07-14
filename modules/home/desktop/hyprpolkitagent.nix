{ ... }: {
  flake.homeModules.hyprpolkitagent = { lib, config, ... }: {
    services.hyprpolkitagent.enable = true;
  };
}
