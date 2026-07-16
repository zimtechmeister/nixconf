{
  perSystem = {
    pkgs,
    ...
  }: {
    packages.starship = pkgs.symlinkJoin {
      name = "starship";
      paths = [ pkgs.starship ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/starship
        makeWrapper ${pkgs.starship}/bin/starship $out/bin/starship \
          --set STARSHIP_CONFIG "${./starship.toml}"
      '';
    };
  };
}
