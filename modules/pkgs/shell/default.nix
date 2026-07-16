# TODO: check if this works as expected and fix if home manager is removed
{
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.shell = let
      # Override the minimal fish package with our customized interactive configurations and packages
      customFish = self'.packages.fish.override {
        extraPackages = with pkgs; [
          lsd
          lazygit
          carapace
          self'.packages.starship
          zoxide
          yazi
        ];
        shellAliases = {
          ls = "lsd -lhAg --group-dirs first --header";
          lg = "lazygit";
        };
        interactiveShellInit = ''
          # Carapace completions
          set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
          carapace _carapace | source

          # Zoxide cd replacement
          zoxide init fish | source

          # Starship prompt
          starship init fish | source

          # Yazi cwd-saving wrapper
          function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          end
        '';
      };
    in
      pkgs.symlinkJoin {
        name = "shell";
        paths = [
          customFish
          # In the future, we can add other wrapped shells (like customZsh, customNushell) here!
        ];

        passthru = {
          shellPath = "/bin/fish";
        };

        meta = {
          mainProgram = "fish";
        };
      };
  };
}
