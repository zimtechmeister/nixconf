{
  flake.nixosModules.mime = {
    xdg.mime.defaultApplications = {
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/*" = "nvim.desktop";

      "image/png" = ["qimgv.desktop" "imv.desktop"];
      "image/jpeg" = ["qimgv.desktop" "imv.desktop"];
      "image/gif" = ["qimgv.desktop" "imv.desktop"];
      "image/*" = ["qimgv.desktop" "imv.desktop"];

      "video/*" = "mpv.desktop";

      "inode/directory" = "org.gnome.Nautilus.desktop";

      "application/pdf" = ["helium.desktop" "zathura.desktop"];
      "text/html" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "x-scheme-handler/webcal" = "helium.desktop";
      "x-scheme-handler/chrome" = "helium.desktop";

    };
  };
}
