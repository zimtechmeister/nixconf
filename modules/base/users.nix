{
  flake.nixosModules.users = {
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
