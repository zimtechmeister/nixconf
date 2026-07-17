{
  lib,
  pkgs,
  inputs,
  theme ? null,
  noctalia,
  ghostty,
  cursor ? null,
  ...
}: let
  # Generate theme.lua
  themeLua = let
    theme' =
      if theme != null
      then theme
      else {};
    colors = let
      allColors = theme'.colors or {};
      filtered = pkgs.lib.filterAttrs (n: v: (pkgs.lib.hasPrefix "base" n) && !(pkgs.lib.hasInfix "-" n)) allColors;
    in
      pkgs.lib.mapAttrs (n: v: "#${v}") filtered;
    fonts = theme'.fonts or {};
    toLuaTableEntries = attrs: let
      processed = pkgs.lib.mapAttrs (n: v:
        if builtins.isAttrs v
        then v.name
        else v)
      attrs;
      stringAttrs = pkgs.lib.filterAttrs (n: v: builtins.isString v) processed;
    in
      pkgs.lib.concatStringsSep "\n    " (pkgs.lib.mapAttrsToList (name: value: "${name} = \"${value}\",") stringAttrs);
  in
    pkgs.writeText "theme.lua" ''
      return {
        colors = {
          ${toLuaTableEntries colors}
        },
        fonts = {
          ${toLuaTableEntries fonts}
        }
      }
    '';

  nixLua = let
    grim = lib.getExe pkgs.grim;
    slurp = lib.getExe pkgs.slurp;
    satty = lib.getExe pkgs.satty;
    screenshot = pkgs.writeShellScript "screenshot" ''
      ${grim} -cg "$(${slurp} -o -d -c '#00000000' -B '#88888888')" -t ppm - | ${satty} --filename - --output-filename $HOME/Pictures/screenshot-$(date '+%Y%m%d-%H:%M:%S').png
    '';
  in
    pkgs.writeText "nix.lua" ''
      return {
        noctalia = "${lib.getExe noctalia}",
        vicinae = "${lib.getExe pkgs.vicinae}",
        ghostty = "${lib.getExe ghostty}",
        screenshot = "${screenshot}",
        ${lib.optionalString (cursor != null) ''
        cursor = {
          name = "${cursor.name}",
          size = ${toString cursor.size},
        },
      ''}
      }
    '';
  # Create a directory for the config files
  configDir = pkgs.symlinkJoin {
    name = "hyprland-config";
    paths = [
      ./lua
      (pkgs.linkFarm "hyprland-theme" [
        {
          name = "theme.lua";
          path = themeLua;
        }
        {
          name = "nix.lua";
          path = nixLua;
        }
      ])
    ];
  };
in
  pkgs.symlinkJoin {
    name = "hyprland";
    inherit (inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland) version;
    passthru = {
      providedSessions = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.providedSessions or [ "hyprland" ];
    };
    paths =
      [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      ]
      ++ lib.optional (cursor != null) cursor.package;

    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/hyprland \
        --add-flags "-c ${configDir}/hyprland.lua" \
        --set HYPRLAND_CONFIG "${configDir}/hyprland.lua" \
        --prefix PATH : "$out/bin"

      if [ -f $out/bin/start-hyprland ]; then
        wrapProgram $out/bin/start-hyprland \
          --set HYPRLAND_CONFIG "${configDir}/hyprland.lua" \
          --prefix PATH : "$out/bin"
      fi
    '';

    meta = {
      mainProgram = "start-hyprland";
    };
  }
