{
  flake.nixosModules.default-apps = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libreoffice-fresh # Office suite
      vlc # Media player
    ];
  };
}
