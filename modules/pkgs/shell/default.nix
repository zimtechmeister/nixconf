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
          superfile
          atuin
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

          # Atuin shell history
          atuin init fish | source

          # Starship prompt
          starship init fish | source
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
