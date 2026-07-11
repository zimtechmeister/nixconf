{
  flake.nixosModules.desktop-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wl-kbptr
      wl-clipboard
      cliphist
      wev

      pulsemixer
      pavucontrol
      easyeffects

      # self.packages.${pkgs.stdenv.hostPlatform.system}.helium # TODO: how do i install it the correct way?

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

      # usefulltools
      switcheroo
      pandoc
      imagemagick

      # t3code # TODO: pnpm vuln
      vicinae

      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
