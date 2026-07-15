{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
      (import ./_stylix-config.nix self.themeNoHash)
    ];
  };

  flake.homeModules.stylix = {
    imports = [
      (import ./_stylix-config.nix self.themeNoHash)
    ];

    home.pointerCursor = {
      # package = pkgs.phinger-cursors;
      # name = "phinger-cursors-dark";
      # size = 24;

      enable = true;
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
    };
  };
}
