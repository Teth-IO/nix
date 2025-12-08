{
  modulesPath,
  lib,
  pkgs,
  inputs,
  ...
} @ args:
{
  nixpkgs.config.allowUnfree = true;

  # niri greeter, display manager, session manager
  programs.dankMaterialShell.greeter = {
    enable = true;
    compositor.name = "niri";  # Or "hyprland" or "sway"
    configHome = "/home/teth-io";
  };

  # niri
  programs.niri = {
    enable = true;
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
    extraGroups  = [ "wheel" "networkmanager" ];
    #hashedPassword ou hashedfile;
  };

  # home-manager
  home-manager = {
    backupFileExtension = "hm-backup";
    users.teth-io = import ./home.nix;
  };

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  # security, polkit, sudo et ulimit 4096
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
    pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }];
  };
  systemd.user.services.niri-flake-polkit.enable = false;

  # keyring (gnome keyring fait aussi le ssh agent)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # boot
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  environment.systemPackages = with pkgs; [
    # Apps
    lutris
    bottles
    steam
    heroic
    yazi
    librewolf
    keepassxc
    mc
    qbittorrent
    waydroid
    seahorse
    owncloud-client
    vscodium

    # cli stack
    foot
    zellij
    nushell

    # Utils
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
    vulkan-tools
  ];
}

