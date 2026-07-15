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
        version = "0.14.5.1";
        src = pkgs.fetchurl {
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
          sha256 = "sha256-JM4Tm4Le9Xcfq3fFMEu/DIK6817FEgBQ2rSwY093F04=";
        };
        appimageContents = pkgs.appimageTools.extractType2 {inherit pname version src;};
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
