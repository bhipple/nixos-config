{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Enable Docker Daemon
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # System profile packages
  environment.systemPackages = with pkgs; [
    dmenu
    gitAndTools.hub
    wget
    xlibs.xmessage

    (haskellPackages.ghcWithPackages (ps: with ps;
      [ xmonad
        xmobar
        xmonad-contrib
        xmonad-extras ]))
  ];

  networking.networkmanager.enable = true;

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
      # zeroconf = {
      #   discovery.enable = true;
      #   publish.enable = true;
      # };
    };
  };

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "0 * * * *  bhipple  /home/bhipple/bin/sync-repos > /tmp/bhipple-sync-repos"
      ];
    };

    postfix = {
      enable = true;
    };

    xserver = {
      enable = true;
      layout = "us";

      # Override the caps-lock key with the compose key
      # See /etc/X11/xkb/rules/evdev.lst for more options
      xkbOptions = "caps:ctrl_modifier";

      # Enable XMonad Configuration extras
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmobar
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
          ];
        };
      };

      desktopManager = {
        plasma5.enable = false;
        xterm.enable = true;
        xfce.enable = true;

        # Just use xmonad
        default = "none";
      };
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };

    ipfs = {
      enable = true;
    };
  };

  programs = {
    adb.enable = true;
    zsh.enable = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bhipple = {
    isNormalUser = true;
    description = "Benjamin Hipple";
    extraGroups = [ "adbusers" "bhipple" "docker" "ipfs" "networkmanager" "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  # Copy this configuration file to
  # /var/run/current-system/configuration.nix
  system.copySystemConfiguration = true;
}
