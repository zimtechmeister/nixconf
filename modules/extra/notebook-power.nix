{
  flake.nixosModules.notebook-power = {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
      logind.settings.Login = {
        HandleLidSwitch = "ignore";
        KillUserProcesses = false;
      };
    };
  };
}
