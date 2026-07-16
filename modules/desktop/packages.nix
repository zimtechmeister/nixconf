{self, ...}: {
  flake.nixosModules.desktop-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wl-kbptr
      wl-clipboard
      cliphist
      wev

      self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty

      pulsemixer
      pavucontrol
      easyeffects

      self.packages.${pkgs.stdenv.hostPlatform.system}.helium
      firefox

      discord
      thunderbird

      nautilus
      kdePackages.dolphin
      simple-mtpfs
      zathura
      mpv
      vlc
      imv
      qimgv

      libreoffice-fresh

      zotero
      anki-bin

      # useful tools
      switcheroo
      pandoc
      imagemagick
    ];
    # Sound (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    security.rtkit.enable = true;

    # Printing / CUPS
    services.printing.enable = true;
  };
}
