{
  flake.nixosModules.ssh = {lib, ...}: {
    programs.ssh.startAgent = lib.mkDefault true;
    services.fail2ban = {
      enable = true;
    };
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
  };
}
