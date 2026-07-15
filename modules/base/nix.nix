{inputs, ...}: {
  flake.nixosModules.nix = {
    imports = [
      inputs.nix-index-database.nixosModules.default
    ];

    # this is for the nixd lsp to get the pkgs from the flake if im correct?
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    programs = {
      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };
      nix-index-database.comma.enable = true;
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
      NH_FLAKE = "/home/tim/nixconf";
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

      settings = {
        trusted-users = [
          "root"
          "tim"
          "@wheel"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"

          "https://hyprland.cachix.org"
          "https://noctalia.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
        experimental-features = ["nix-command" "flakes"];
      };
    };
    nixpkgs.config.allowUnfree = true;
  };
}
