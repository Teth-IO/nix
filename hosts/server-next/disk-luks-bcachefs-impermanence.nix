{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "bcachefs";
                  filesystem = "permanence";
                  label = "os.os1";
                  extraFormatArgs = [
                    "--discard"
                    "--force"
                  ];
                };
              };
            };
          };
        };
      };
    };
    bcachefs_filesystems = {
      permanence = {
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=lz4"
          "--background_compression=lz4"
        ];
        subvolumes = {
          "subvolumes/nix" = {
            mountpoint = "/nix";
          };
        };
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1G"
          "mode=755"
        ];
      };
    };
  };
}
