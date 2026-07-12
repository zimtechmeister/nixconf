{
  flake.nixosModules.users = {config, ...}: {
    users.users = {
      "tim" = {
        isNormalUser = true;
        description = "tim";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        useDefaultShell = true;
        hashedPasswordFile = config.age.secrets.tim-password.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLOQ37NzU1kJ7ZIgl1t03/z7uiQ0kQ969hQ7U5nY9bY desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9wmhtXaBDDL88/DW/yzjX2Hf37kRwWgpTFjxlg+cgL tim@t480"
        ];
      };
      "root" = {
        hashedPasswordFile = config.age.secrets.root-password.path;
        # NOTE: when using nixos-anywhere
        # openssh.authorizedKeys.keys = [
        #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLOQ37NzU1kJ7ZIgl1t03/z7uiQ0kQ969hQ7U5nY9bY desktop"
        # ];
      };
    };
  };
}
