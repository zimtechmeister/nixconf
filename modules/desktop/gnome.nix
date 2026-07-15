{
  flake.nixosModules.gnome = {
    lib,
    pkgs,
    ...
  }: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure GNOME Software Suite and related services.
    services.flatpak.enable = true;

    # Ensure GNOME Software is installed along with some useful extensions/tools.
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      gnome-clocks
      gnome-calculator
      nautilus
      evince
      file-roller
      seahorse
    ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.ssh.startAgent = lib.mkForce false;
  };
}
