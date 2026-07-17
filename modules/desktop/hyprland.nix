{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {
    pkgs,
    lib,
    config,
    ...
  }: {
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
      rtkit

      phinger-cursors

      hyprpicker
      nwg-displays

      vicinae
    ];

    # Enable dconf system-wide and configure interface preferences
    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "phinger-cursors-dark";
            cursor-size = lib.gvariant.mkInt32 24;
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":";
          };
        };
      }
    ];

    # Enable greetd display manager with tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --user-menu --cmd start-hyprland --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions";
          user = "greeter";
        };
      };
    };
  };
}
