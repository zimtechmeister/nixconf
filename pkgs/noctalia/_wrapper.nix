{
  pkgs,
  inputs,
  ...
}: let
  configDir = pkgs.linkFarm "noctalia-config" [
    {
      name = "noctalia-config.toml";
      path = ./noctalia-config.toml;
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
        --set NOCTALIA_CONFIG_DIR "${configDir}" \
        --prefix PATH : "$out/bin"
    '';

    meta = {
      mainProgram = "noctalia";
    };
  }
