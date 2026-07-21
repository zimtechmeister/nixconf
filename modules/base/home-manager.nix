{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = {inherit inputs self;};
      users.tim = {
        home = {
          username = "tim";
          homeDirectory = "/home/tim";

          stateVersion = "26.05";
        };
        # Let's Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
    };
  };
}
