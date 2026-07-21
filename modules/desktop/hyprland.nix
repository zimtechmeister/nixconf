{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    environment.systemPackages = with pkgs; [
      rtkit

      hyprpicker
      nwg-displays

      vicinae
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

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/wm/preferences" = {
              button-layout = ":";
            };
          };
        }
      ];
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
}
