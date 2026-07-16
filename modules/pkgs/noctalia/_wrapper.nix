{
  pkgs,
  inputs,
  theme ? null,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/qr/wallhaven-qrr21r.png";
    hash = "sha256-P/dy3Oiup0UC+ApPI+HBlJEYQ9w/gATlHX1FKnNZb08=";
  };

  paletteJSON =
    if theme == null
    then ./palettes/nix.json
    else let
      colors = theme.colors;
      c = name: "#${colors.${name}}";
    in
      pkgs.writeText "nix.json" (builtins.toJSON {
        dark = {
          mPrimary = c "base14";
          mOnPrimary = c "base00";
          mSecondary = c "base13";
          mOnSecondary = c "base00";
          mTertiary = c "base16";
          mOnTertiary = c "base00";
          mError = c "base12";
          mOnError = c "base00";
          mSurface = c "base00";
          mOnSurface = c "base06";
          mSurfaceVariant = c "base01";
          mOnSurfaceVariant = c "base05";
          mOutline = c "base02";
          mShadow = c "base00";
          mHover = c "base16";
          mOnHover = c "base00";
          terminal = {
            background = c "base00";
            foreground = c "base05";
            cursor = c "base05";
            cursorText = c "base00";
            selectionBg = c "base03";
            selectionFg = c "base05";
            normal = {
              black = c "base00";
              red = c "base08";
              green = c "base0B";
              yellow = c "base0A";
              blue = c "base0D";
              magenta = c "base0E";
              cyan = c "base0C";
              white = c "base04";
            };
            bright = {
              black = c "base04";
              red = c "base12";
              green = c "base14";
              yellow = c "base13";
              blue = c "base16";
              magenta = c "base17";
              cyan = c "base15";
              white = c "base05";
            };
          };
        };
      });

  configFile = pkgs.runCommand "settings.toml" {} ''
    cat ${./settings.toml} > $out
    cat <<EOF >> $out

    [wallpaper.default]
    path = "${wallpaper}"
    EOF
  '';

  configDir = pkgs.linkFarm "settings" [
    {
      name = "noctalia/settings.toml";
      path = configFile;
    }
    {
      name = "noctalia/palettes/nix.json";
      path = paletteJSON;
    }
  ];
in
  pkgs.symlinkJoin {
    name = "noctalia";
    inherit (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default) version;
    paths = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/noctalia \
        --set NOCTALIA_CONFIG_HOME "${configDir}" \
        --prefix PATH : "$out/bin"
    '';

    meta = {
      mainProgram = "noctalia";
    };
  }
