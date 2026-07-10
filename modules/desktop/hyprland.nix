{
  flake.nixosModules.hyprland = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      hyprpicker
      nwg-displays
    ];
  };
}
