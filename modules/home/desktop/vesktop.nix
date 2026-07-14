{ ... }: {
  flake.homeModules.vesktop = { lib, config, ... }: {
    programs.vesktop = {
      enable = true;
      settings = {
        minimizeToTray = false;
        tray = false;
      };
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        plugins = {
          FakeNitro.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          ServerInfo.enabled = true;
          ShowConnections.enabled = true;
          ShowHiddenChannels.enabled = true;
          VoiceChatDoubleClick.enabled = true;
          VolumeBooster.enabled = true;
        };
      };
    };
  };
}
