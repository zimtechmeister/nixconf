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
  }: let
    themeSlug = "gruvbox-dark-hard";
    gtkThemePkg = inputs.basix.packages.${pkgs.stdenv.hostPlatform.system}."gtk-${themeSlug}";
    qtThemePkg = inputs.basix.packages.${pkgs.stdenv.hostPlatform.system}."qt5ct-${themeSlug}";
  in {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    environment.systemPackages = with pkgs; [
      rtkit

      hyprpicker
      nwg-displays

      vicinae

      # Basix GTK & Qt theme packages
      gtkThemePkg
      qtThemePkg

      # qt theming
      libsForQt5.qt5ct
      qt6Packages.qt6ct

      phinger-cursors
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
            "org/gnome/desktop/interface" = {
              cursor-theme = "phinger-cursors-dark";
              cursor-size = lib.gvariant.mkInt32 24;

              color-scheme = "prefer-dark";
              gtk-theme = "basix-${themeSlug}";
            };
            "org/gnome/desktop/wm/preferences" = {
              button-layout = ":";
            };
          };
        }
      ];
    };
    qt.platformTheme = "qt5ct";

    environment.etc."xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=basix-${themeSlug}
      gtk-application-prefer-dark-theme=1
    '';

    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";

      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      GTK_THEME = "basix-${themeSlug}";
      QT_QPA_PLATFORMTHEME = "qt5ct";

      XCURSOR_THEME = "phinger-cursors-dark";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "phinger-cursors-dark";
      HYPRCURSOR_SIZE = "24";
    };
  };
}
