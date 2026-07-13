{
  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts.fontconfig.enable = true;
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      maple-mono.NF
      monocraft
      nerd-fonts.terminess-ttf
      nerd-fonts.fira-code
      nerd-fonts.geist-mono
      nerd-fonts.jetbrains-mono

      geist-font

      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      google-fonts
    ];
  };
}
