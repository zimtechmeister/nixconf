{ ... }: {
  flake.homeModules.ssh = { lib, config, ... }: {
    services.ssh-agent.enable = true;
  };
}
