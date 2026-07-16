# TODO: does not work dont know how to implement maybe use a display manager
{ self, ... }: {
  flake.homeModules.autostart-hyprland = { lib, pkgs, ... }: let
    start-hyprland = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    autostart-hyprland = pkgs.writeShellScript "autostart-hyprland" ''
      # if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      if [[ -z $DISPLAY ]] && [[ "$XDG_VTNR" = 1 ]]; then
        exec ${start-hyprland}
      fi
    '';
  in {
    xdg.configFile."fish/conf.d/autostart.fish".text = ''
      if status is-login
        ${autostart-hyprland}
      end
    '';
  };
}
