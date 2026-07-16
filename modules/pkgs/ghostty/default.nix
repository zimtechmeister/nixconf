{
  perSystem = {
    pkgs,
    theme,
    ...
  }: let
    nixTheme= pkgs.writeText "nix-theme" ''
      palette = 0=#${theme.colors.base00}
      palette = 1=#${theme.colors.base08}
      palette = 2=#${theme.colors.base0B}
      palette = 3=#${theme.colors.base0A}
      palette = 4=#${theme.colors.base0D}
      palette = 5=#${theme.colors.base0E}
      palette = 6=#${theme.colors.base0C}
      palette = 7=#${theme.colors.base03}
      palette = 8=#${theme.colors.base04}
      palette = 9=#${theme.colors.base12}
      palette = 10=#${theme.colors.base14}
      palette = 11=#${theme.colors.base13}
      palette = 12=#${theme.colors.base16}
      palette = 13=#${theme.colors.base17}
      palette = 14=#${theme.colors.base15}
      palette = 15=#${theme.colors.base05}
      background = #${theme.colors.base00}
      foreground = #${theme.colors.base05}
      cursor-color = #${theme.colors.base05}
      cursor-text = #${theme.colors.base00}
      selection-background = #${theme.colors.base03}
      selection-foreground = #${theme.colors.base05}
    '';
  in {
    packages.ghostty = pkgs.symlinkJoin {
      name = "ghostty";
      paths = [ pkgs.ghostty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/ghostty
        makeWrapper ${pkgs.ghostty}/bin/ghostty $out/bin/ghostty \
          --add-flags "--config-file=${nixTheme}" \
          --add-flags "--config-file=${./config}"
      '';
      meta.mainProgram = "ghostty";
    };
  };
}
