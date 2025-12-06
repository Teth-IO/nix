{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                    subvolumes = {
                      "/" = {
                        mountOptions = [ 
                          "rw"
                          "noatime"
                          "ssd"
                          "space_cache=v2"
                          "compress-force=zstd:1" 
                        ];
                        mountpoint = "/";
                      };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}