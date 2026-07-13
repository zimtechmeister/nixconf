{inputs, ...}: {
  flake.nixosModules.nix = {
    # this is for the nixd lsp to get the pkgs from the flake if im correct?
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    programs = {
      # nix-index = {
      #   enable = true;
      #   enableFishIntegration = true;
      # };
      # nix-index-database.comma.enable = true;
      nh = {
        enable = true;
        # clean = {
        #   enable = true;
        #   extraArgs = "--keep 3 --keep-since 3d";
        #   dates = "hourly";
        # };
      };
    };
    environment.sessionVariables = {
      NH_FLAKE = "/home/tim/flocke";
    };
    nix = {
      gc = {
        automatic = true;
        dates = "01:00";
        randomizedDelaySec = "45min";
        persistent = true;
        options = "--delete-older-than 3d";
      };
      optimise = {
        automatic = true;
        dates = ["03:45"];
        randomizedDelaySec = "45min";
        persistent = true;
      };
    };
  };
}
