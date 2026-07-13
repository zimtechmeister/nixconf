{
  flake.nixosModules.television = {
    programs.television = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
