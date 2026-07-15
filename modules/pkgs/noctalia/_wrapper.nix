{
  pkgs,
  inputs,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/qr/wallhaven-qrr21r.png";
    hash = "sha256-P/dy3Oiup0UC+ApPI+HBlJEYQ9w/gATlHX1FKnNZb08=";
  };

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
