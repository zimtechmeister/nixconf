{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.default-apps = {
    config,
    lib,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      libreoffice-fresh # Office suite
      vlc # Media player
      gimp # Image editor
      thunderbird # Email client
      transmission_4-gtk # Torrent client (GNOME/GTK themed)
      bitwarden-desktop # Password manager
    ];
  };
}
