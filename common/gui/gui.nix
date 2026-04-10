{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  imports = [ 
    inputs.niri.nixosModules.niri
  ];

  nixpkgs.overlays = [ 
    inputs.niri.overlays.niri
    (final: prev: {
    # on créer kernllvmPackages au lieu de remplacer llvmPackages lui même sinon tout les packets en clang vont devoir être recompiler comme aucun artefact correspond à ces builds ne sera dans le cache
    kernllvmPackages = prev.llvmPackages // {
      stdenv = prev.llvmPackages.stdenv // {
        mkDerivation =
          attrs:
          (prev.llvmPackages.stdenv.mkDerivation attrs).overrideAttrs (this: {
            env = (this.env or { }) // {
              # Fix `--target` spam.
              NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
              # Fix `-nostdinc` warnings.
              NIX_CFLAGS_COMPILE = prev.lib.concatStringsSep " " [
                (this.env.NIX_CFLAGS_COMPILE or "")
                "-Wno-unused-command-line-argument"
              ];
            };
          });
      };
    };
  })
  ];
    
  # niri
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      nerd-fonts.blex-mono
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Inter" ];
      };
      antialias = true;
    };
  };

  # BTFS
  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
  };

  # audio
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  # user management
  users.mutableUsers = false;
  users.users.teth-io = {
    isNormalUser  = true;
    home  = "/home/teth-io";
    extraGroups  = [ "wheel" "networkmanager" "libvirtd" "gamemode" "openrazer" ];
    hashedPassword = "redacted";
  };

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  # security
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
  };
  systemd.user.services.niri-flake-polkit.enable = false;

  # increase max number of open file
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "65536";
  }{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";  
  }];

  # virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # flatpak si besoin
  services.flatpak.enable = true;

  # nautilus
  services.gvfs.enable = true;

  # correction agent ssh
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.startAgent = true;

  # sops-nix
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  sops.secrets.keepass = {
    format = "binary";
    sopsFile = ./secrets/keepass;
    mode = "444";
  };

  environment.systemPackages = with pkgs; [
    ## Apps
    yazi
    librewolf
    keepassxc
    mc
    qbittorrent
    seahorse
    owncloud-client
    xnviewmp
    (flameshot.override { enableWlrSupport = true; })
    nautilus
    file-roller
    wl-clipboard
    tor-browser

    ## cli stack
    foot
    fish

    ## programming
    nil
    nixfmt
    texlive.combined.scheme-full
    
    ## Utils
    zip
    unzip
    git
    lazygit
    pavucontrol
    brightnessctl
    coreutils
    file
    findutils
    libnotify
    matugen
    usbutils
    ueberzugpp
    binutils
    pciutils
    dnsmasq
    fastfetch
    pciutils
    lshw
    fd
    age
    sops
  ];
}
