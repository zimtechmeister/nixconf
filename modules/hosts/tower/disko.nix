{
  flake.diskoConfigurations.tower = {
    disko.devices = {
      disk.main = {
        device = "/dev/disk/by-id/ata-M.2_SSD_512GB_200089100434";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"]; # security measurements only root can edit /boot
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            bcachefs = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "pool";
                label = "ssd";
              };
            };
          };
        };
      };
      bcachefs_filesystems = {
        pool = {
          type = "bcachefs_filesystem";
          passwordFile = "/tmp/disk.key";
          # disko has a known upstream bug (Issue #1253
          # https://github.com/nix-community/disko/issues/1253) where defining
          # multiple subvolumes under an encrypted bcachefs_filesystem causes
          # Disko to attempt unlocking the disk multiple times sequentially.
          # this is why i 
          mountpoint = "/";
          mountOptions = ["noatime"];
          extraFormatArgs = [
            "--compression=zstd"
            "--background_compression=zstd"
          ];
          # subvolumes = {
          #   "subvolumes/root" = {
          #     mountpoint = "/";
          #     mountOptions = ["noatime"];
          #   };
          #   "subvolumes/home" = {
          #     mountpoint = "/home";
          #     mountOptions = ["noatime"];
          #   };
          # };
        };
      };
    };
  };
}
