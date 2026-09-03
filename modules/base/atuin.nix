{
  flake.nixosModules.atuin = {
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        update_check = false;
        sync_address = "https://api.atuin.sh";
        sync_frequency = "1h";
        search_mode = "fuzzy";
        filter_mode = "global";
        style = "compact";
        inline_height = 0;
      };
    };
  };
}
