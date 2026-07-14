{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations."tim" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {inherit inputs self;};
    modules = [
      self.homeModules.default
      self.homeModules.desktop
      inputs.stylix.homeModules.stylix
      self.homeModules.stylix
    ];
  };

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
        imports = [
          self.homeModules.default
          self.homeModules.desktop
          self.homeModules.stylix
        ];
      };
    };
  };
}
