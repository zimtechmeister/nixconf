{
  flake.nixosModules.notebook-power = {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
      logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchDocked = "ignore"; # Keeps the laptop awake if plugged into an external monitor
      };
    };
  };
}
