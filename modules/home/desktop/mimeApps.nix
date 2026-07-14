{ ... }: {
  flake.homeModules.mimeApps = { lib, config, ... }: {
    xdg = {
      terminal-exec = {
        enable = true;
        settings = {
          default = ["ghostty.desktop"];
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/*" = ["nvim.desktop"];
          "image/*" = ["qimgv.desktop" "imv.desktop"];
          "video/*" = ["mpv.desktop"];
          "inode/directory" = ["org.gnome.Nautilus.desktop"];
          "application/pdf" = ["helium.desktop" "zathura.desktop"];
          "text/html" = ["helium.desktop"];
          "x-scheme-handler/about" = ["helium.desktop"];
          "x-scheme-handler/http" = ["helium.desktop"];
          "x-scheme-handler/https" = ["helium.desktop"];
          "x-scheme-handler/unknown" = ["helium.desktop"];
          "x-scheme-handler/webcal" = ["helium.desktop"];
          "x-scheme-handler/chrome" = ["helium.desktop"];
        };
      };
    };
  };
}
