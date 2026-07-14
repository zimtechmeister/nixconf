{ self, ... }: {
  flake.homeModules.autostart-hyprland = { lib, config, pkgs, ... }: let
    start-hyprland = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    autostart-hyprland = pkgs.writeShellScript "autostart-hyprland" ''
      # if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      if [[ -z $DISPLAY ]] && [[ "$XDG_VTNR" = 1 ]]; then
        exec ${start-hyprland}
      fi
    '';
  in {
    programs.fish.loginShellInit = ''
      ${autostart-hyprland}
    '';
  };
}
