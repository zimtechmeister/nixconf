{
  perSystem = {
    pkgs,
    theme,
    ...
  }: let
    nixTheme = pkgs.writeTextDir "share/ghostty/themes/nixTheme" ''
      palette = 0=#${theme.colors.base00}
      palette = 1=#${theme.colors.base08}
      palette = 2=#${theme.colors.base0B}
      palette = 3=#${theme.colors.base0A}
      palette = 4=#${theme.colors.base0D}
      palette = 5=#${theme.colors.base0E}
      palette = 6=#${theme.colors.base0C}
      palette = 7=#${theme.colors.base03}
      palette = 8=#${theme.colors.base04}
      palette = 9=#${theme.colors.base12}
      palette = 10=#${theme.colors.base14}
      palette = 11=#${theme.colors.base13}
      palette = 12=#${theme.colors.base16}
      palette = 13=#${theme.colors.base17}
      palette = 14=#${theme.colors.base15}
      palette = 15=#${theme.colors.base05}
      background = #${theme.colors.base00}
      foreground = #${theme.colors.base05}
      cursor-color = #${theme.colors.base05}
      cursor-text = #${theme.colors.base00}
      selection-background = #${theme.colors.base03}
      selection-foreground = #${theme.colors.base05}
    '';
  in {
    packages.ghostty-wrapped = pkgs.symlinkJoin {
      name = "ghostty-wrapped";
      paths = [
        pkgs.ghostty
        nixTheme
      ];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        # Wrap ghostty (fully configured with the custom config file)
        wrapProgram $out/bin/ghostty \
          --add-flags "--config-file=${./config}" \
          --set GHOSTTY_RESOURCES_DIR "$out/share/ghostty" \
          --prefix PATH : "$out/bin"

        # Rename the wrapper binary to ghostty-wrapped
        mv $out/bin/ghostty $out/bin/ghostty-wrapped

        # Fix hardcoded paths in desktop files, shell completions, and other integration files
        upstream="${pkgs.ghostty}"

        # Recursively replace directory symlinks under $out (except bin/) with real directories
        # so we can write to the files inside them.
        resolve_dir_symlinks() {
          local dir="$1"
          find "$dir" -mindepth 1 -maxdepth 1 -type l | while read -r sym; do
            if [ -d "$sym" ]; then
              local target
              target=$(readlink "$sym")
              rm "$sym"
              mkdir -p "$sym"
              cp -r "$target"/* "$sym/"
              resolve_dir_symlinks "$sym"
            fi
          done
        }

        # Resolve all directory symlinks under $out/share
        if [ -d "$out/share" ]; then
          resolve_dir_symlinks "$out/share"
        fi

        # Rename desktop files to avoid name collisions and update their contents
        find "$out/share" -name "*ghostty*.desktop" | while read -r file; do
          dir=$(dirname "$file")
          base=$(basename "$file")
          new_base=$(echo "$base" | sed 's/ghostty/ghostty-wrapped/')
          new_file="$dir/$new_base"
          
          # If it's a symlink, copy the target to make it a writable file
          if [ -L "$file" ]; then
            target=$(readlink "$file")
            cp "$target" "$new_file"
            rm "$file"
          else
            mv "$file" "$new_file"
          fi
          
          chmod +w "$new_file"
          substituteInPlace "$new_file" \
            --replace "Name=Ghostty" "Name=Ghostty (Wrapped)" \
            --replace "Exec=ghostty" "Exec=ghostty-wrapped"
        done

        # Find and replace all references to upstream ghostty in text files, pruning bin/ to avoid wrapper loops
        find -L "$out" -path "$out/bin" -prune -o -type f | while read -r file; do
          if grep -qI "$upstream" "$file"; then
            if [ -L "$file" ]; then
              target=$(readlink "$file")
              rm "$file"
              cp "$target" "$file"
            fi
            chmod +w "$file"
            substituteInPlace "$file" \
              --replace-quiet "$upstream/bin/ghostty" "$out/bin/ghostty-wrapped" \
              --replace-quiet "$upstream/bin/" "$out/bin/"
          fi
        done
      '';
      meta.mainProgram = "ghostty-wrapped";
    };
  };
}
