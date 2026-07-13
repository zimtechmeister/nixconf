{
  flake.nixosModules.ssh = {
    programs.ssh.startAgent = true;
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
