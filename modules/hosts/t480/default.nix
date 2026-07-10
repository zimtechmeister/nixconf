{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostT480
    ];
  };

  flake.nixosModules.hostT480 = {
    imports = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.t480
      ./_hardware-configuration.nix
      self.nixosModules.base
      self.nixosModules.gnome
      self.nixosModules.base-packages
      self.nixosModules.desktop-packages
    ];

    networking.hostName = "t480";

    users.users = {
      "tim" = {
        isNormalUser = true;
        description = "tim";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        useDefaultShell = true;
        initialPassword = "nixos"; # TODO: agenix
      };
      "root" = {
        initialPassword = "nixos"; # TODO: agenix
      };
    };
  };
}
