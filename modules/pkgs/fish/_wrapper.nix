{
  pkgs,
  ...
}: let
  # Tools that fish needs for its interactive functions/aliases/prompts
  extraPackages = with pkgs; [
    lsd
    lazygit
    carapace
    starship
    zoxide
    yazi
  ];

  # The interactive fish config snippet
  interactiveConfig = pkgs.writeText "interactive.fish" ''
    if status is-interactive
      # Disable fish greeting
      set -g fish_greeting

      # Use vi key bindings
      fish_vi_key_bindings

      # Shell Aliases
      alias grep="grep -i --color=auto"
      alias mv="mv -i"
      alias cp="cp -i"
      alias ls="lsd -lhAg --group-dirs first --header"
      alias lg="lazygit"

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
    end
  '';
in
  pkgs.symlinkJoin {
    name = "fish";
    paths = [ pkgs.fish ] ++ extraPackages;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # Remove the un-wrapped symlink to fish
      rm $out/bin/fish

      # Create our wrapped fish binary that runs with PATH prefix containing our extraPackages
      makeWrapper ${pkgs.fish}/bin/fish $out/bin/fish \
        --prefix PATH : "$out/bin"

      # Install the interactive config file into the fish vendor directory
      mkdir -p $out/share/fish/vendor_conf.d
      cp ${interactiveConfig} $out/share/fish/vendor_conf.d/interactive.fish
    '';

    passthru = {
      shellPath = "/bin/fish";
    };

    meta = {
      mainProgram = "fish";
    };
  }
