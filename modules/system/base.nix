{
  flake.nixosModules.base = {pkgs, ...}: {
    # Nix settings
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;

    # Bootloader
    boot.loader.limine = {
      enable = true;
      package = pkgs.limine-full;
      secureBoot = {
        enable = true;
        sbctl = pkgs.sbctl;
        autoGenerateKeys = true;
        autoEnrollKeys = {
          enable = true;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      sbctl
    ];
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 5;

    # Networking
    networking.networkmanager.enable = true;
    # networking.hostName; declared in host-specific configuration

    # Time and Locale
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    # Sound (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    security.rtkit.enable = true;

    # Printing / CUPS
    services.printing.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Touchpad tap-to-click
    services.libinput.enable = true;

    # Basic system utilities
    # environment.systemPackages = with pkgs; [
    #   git
    #   curl
    #   wget
    #   vim
    #   htop
    # ];

    # Essential firmware
    hardware.enableAllFirmware = true;

    system.stateVersion = "26.05";
  };
}
