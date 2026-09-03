{
  flake.nixosModules.newt = {
    environment.etc."newt-secret".text = ''
    '';
    services.newt = {
      enable = true;
      # settings = {
      #   endpoint = "https://pangolin.timzechmeister.de";
      # };
      environmentFile = "/etc/newt-secret";
    };
  };
}
