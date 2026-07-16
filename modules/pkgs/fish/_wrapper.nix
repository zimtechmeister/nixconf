{
  pkgs,
  makeWrapper,
  symlinkJoin,
  writeText,
  fish,
  extraPackages ? [],
  interactiveShellInit ? "",
  shellAliases ? {},
}: let
  # Default minimal interactive config
  defaultInteractiveConfig = ''
    if status is-interactive
      # Disable fish greeting
      set -g fish_greeting

      # Use vi key bindings
      fish_vi_key_bindings

      # Default minimal Shell Aliases
      alias grep="grep -i --color=auto"
      alias mv="mv -i"
      alias cp="cp -i"
    end
  '';

  # Generate the alias fish script from the shellAliases attrset
  aliasLines = pkgs.lib.mapAttrsToList (name: value: "alias ${name}=\"${value}\"") shellAliases;
  aliasConfig = pkgs.lib.concatStringsSep "\n" aliasLines;

  # Combined config
  combinedConfig = writeText "interactive.fish" ''
    ${defaultInteractiveConfig}

    if status is-interactive
      # Custom aliases
      ${aliasConfig}

      # Custom interactive shell init
      ${interactiveShellInit}
    end
  '';
in
  symlinkJoin {
    name = "fish";
    paths = [ fish ] ++ extraPackages;

    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      # Remove the un-wrapped symlink to fish
      rm $out/bin/fish

      # Create our wrapped fish binary that runs with PATH prefix containing our extraPackages
      makeWrapper ${fish}/bin/fish $out/bin/fish \
        --prefix PATH : "$out/bin"

      # Install the interactive config file into the fish vendor directory
      mkdir -p $out/share/fish/vendor_conf.d
      cp ${combinedConfig} $out/share/fish/vendor_conf.d/interactive.fish
    '';

    passthru = {
      shellPath = "/bin/fish";
    };

    meta = {
      mainProgram = "fish";
    };
  }
