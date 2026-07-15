{self, ...}: {
  flake.nixosModules.base-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      vim
      helix
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

      yt-dlp
      antigravity-cli

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
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    virtualisation.docker.enable = true;
  };
}
