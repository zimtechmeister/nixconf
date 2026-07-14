{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
      withUWSM = false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
      hyprpicker
      nwg-displays
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

      ghostty # should not be here
      vicinae # this too
    ];
  };
}
