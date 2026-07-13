{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.base-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      vim
      helix # TODO: try it
      jq
      htop
      ripgrep
      less
      man
      man-db
      man-pages
      trash-cli

      fd
      smartmontools
      bat
      difftastic
      tealdeer
      bottom
      lazygit
      killall
      gzip
      zip
      unzip
      cpio
      ntfs3g
      wireguard-tools
      openconnect
      openvpn
      pass

      yt-dlp # TODO: pnpm vuln
      antigravity-cli

      inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien

      # Languages
      openjdk25
      rlwrap

      typst

      gcc
      gnumake
      cmake
      meson

      nodejs
      yarn
      bun

      R

      python3
      pipenv

      rustc
      cargo
    ];
    virtualisation.docker.enable = true;
  };
}
