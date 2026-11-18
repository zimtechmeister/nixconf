{...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages =
      if system == "x86_64-linux"
      then let
        pname = "helium";
        version = "0.22.0.1";
        src = pkgs.fetchurl {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          sha256 = "sha256-wZaSYOtv10FejNj7UZtKZlKZ+vCZxUb0heiH3a2HB80=";
        };
        appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
      in {
        helium = pkgs.appimageTools.wrapType2 {
          inherit pname version src;
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
            install -m 444 -D ${appimageContents}/helium.png $out/share/icons/hicolor/512x512/apps/helium.png
            substituteInPlace $out/share/applications/helium.desktop \
              --replace 'Exec=AppRun' 'Exec=helium'
          '';
        };
      }
      else {};
  };
}
