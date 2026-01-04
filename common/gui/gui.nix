{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
} @ args:
{
  nixpkgs.config.allowUnfree = true;

  imports = [ inputs.niri.nixosModules.niri ];
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

  # niri greeter, display manager, session manager
  programs.dankMaterialShell.greeter = {
    enable = true;
    compositor.name = "niri";  # Or "hyprland" or "sway"
    configHome = "/home/teth-io";
  };

  # niri
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # obligé sinon home-manager plante
  programs.dconf.enable = true;

  # fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      nerd-fonts.blex-mono
    ];
  };

  # BTFS
  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
    extraGroups  = [ "wheel" "networkmanager" "libvirtd" ];
    hashedPassword = "redacted";
  };

  # home-manager
  home-manager = {
    backupFileExtension = "hm-backup";
    users.teth-io = import ./home.nix;
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

  # keyring (gnome keyring fait aussi le ssh agent)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # increase max number of open file
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "4096";
  }];

  # virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    ## Apps
    #lutris
    #bottles
    steam
    #heroic
    yazi
    librewolf
    keepassxc
    mc
    qbittorrent
    waydroid
    seahorse
    owncloud-client
    vscodium
    xnviewmp
    (flameshot.override { enableWlrSupport = true; })

    ## cli stack
    foot
    zellij
    nushell

    ## Utils
    zip
    unzip
    git
    lazygit
    btop
    gdu
    dysk
    pavucontrol
    protontricks
    lact
    gh
    bash
    brightnessctl
    cava
    coreutils
    ddcutil
    file
    findutils
    libnotify
    matugen
    usbutils
    ueberzugpp
    binutils
    dnsmasq
    fastfetch
  ];
}
