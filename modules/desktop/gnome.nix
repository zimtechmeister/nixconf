{ self, inputs, ... }: {
  flake.nixosModules.gnome = { config, lib, pkgs, ... }: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Configure GNOME Software Suite and related services.
    services.flatpak.enable = true;

    # Ensure GNOME Software is installed along with some useful extensions/tools.
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      gnome-weather
      gnome-maps
      gnome-clocks
      gnome-calculator
      gnome-calendar
      gnome-music
      gnome-photos
      nautilus
      evince
      file-roller
      seahorse
    ];
  };
}
