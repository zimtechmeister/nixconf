{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    programs.noctalia = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
      systemd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      hyprpicker
      nwg-displays

      ghostty # should not be here
      vicinae # this too
    ];
  };
}
