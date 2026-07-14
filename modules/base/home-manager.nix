{ self, inputs, ... }: {
  flake.nixosModules.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = { inherit inputs self; };
      users.tim = {
        imports = [
          self.homeModules.default
        ];
      };
    };
  };
}
