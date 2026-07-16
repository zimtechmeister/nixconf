{
  flake.nixosModules.zoxide = {
    programs.zoxide = {
      enable = true;
      flags = [
        "--cmd cd"
      ];
    };
  };
}
